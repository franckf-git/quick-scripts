package main

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"os/exec"
	"time"
)

// I know, a lot of bad practises, it is a quick script - will refacto if I have time (spoiler: probably not)
// comments on issues not included, no big values, and need access token

var username string
var testGroupID int
var pagination string

type repo struct {
	gitUrl    string
	projectID int
	name      string
}

func init() {
	username = os.Getenv("GITLAB_USERNAME")
	if username == "" {
		username = "franckf"
	}
	testGroupID = 15941316
	pagination = fmt.Sprint(100)
}

func main() {
	var backupFolder string = os.Getenv("HOME") + "/git_backup_" + time.Now().Format(time.RFC3339)
	var err error
	err = os.MkdirAll(backupFolder, 0755)
	err = os.Chdir(backupFolder)
	if err != nil {
		log.Fatal(err)
	}

	var id int
	id = idUsername(username)

	var projectsFromUser []repo
	var projectsFromGroup []repo
	projectsFromUser = getIDandGitFromIDs(id)
	projectsFromGroup = getIDandGitFromIDsGroup(testGroupID)

	var allProjects []repo
	allProjects = append(projectsFromUser, projectsFromGroup...)

	for _, depot := range allProjects {
		fmt.Println("Start backup of", depot.name, depot.gitUrl)
		var repoFolder = backupFolder + "/" + depot.name
		var err error
		err = os.MkdirAll(repoFolder, 0755)
		err = os.Chdir(repoFolder)
		var cmd *exec.Cmd
		var cloning string = "git clone " + depot.gitUrl
		cmd = exec.Command("bash", "-c", cloning)
		_, err = cmd.CombinedOutput()
		var urlProject string = "https://gitlab.com/api/v4/projects/" + fmt.Sprint(depot.projectID)
		var bodyProject []byte
		bodyProject = wget(urlProject)
		err = writeToFile(bodyProject, "project.json")
		var bodyIssues []byte
		bodyIssues = wget(urlProject + "/issues")
		err = writeToFile(bodyIssues, "issues.json")
		if err != nil {
			log.Fatal(err)
		}
	}
}

func writeToFile(body []byte, filename string) (err error) {
	err = os.WriteFile(filename, body, 0755)
	return
}

func idUsername(username string) (id int) {
	var url string
	url = "https://gitlab.com/api/v4/users?username=" + username
	var body []byte
	body = wget(url)

	type idUser struct {
		Id int `json:"id"`
	}
	var result []idUser
	json.Unmarshal(body, &result)

	id = result[0].Id
	return
}

func getIDandGitFromIDs(id int) (repos []repo) {
	var url string
	url = "https://gitlab.com/api/v4/users/" + fmt.Sprint(id) + "/projects?order_by=name&per_page=" + pagination + "&sort=asc"

	var body []byte
	body = wget(url)
	var err error
	err = writeToFile(body, "projects.json")
	if err != nil {
		log.Fatal(err)
	}

	type project struct {
		Id      int    `json:"id"`
		GitLink string `json:"http_url_to_repo"`
		Name    string `json:"path"`
	}
	var projects []project
	json.Unmarshal(body, &projects)

	for _, projectInfos := range projects {
		repos = append(repos, repo{
			gitUrl:    projectInfos.GitLink,
			projectID: projectInfos.Id,
			name:      projectInfos.Name,
		})
	}
	return
}

func getIDandGitFromIDsGroup(id int) (repos []repo) {
	var url string
	url = "https://gitlab.com/api/v4/groups/" + fmt.Sprint(id)

	var body []byte
	body = wget(url)
	var err error
	err = writeToFile(body, "groups.json")
	if err != nil {
		log.Fatal(err)
	}

	type project struct {
		Id      int    `json:"id"`
		GitLink string `json:"http_url_to_repo"`
		Name    string `json:"path"`
	}
	type group struct {
		Projects []project `json:"projects"`
	}
	var projects group
	json.Unmarshal(body, &projects)

	for _, projectInfos := range projects.Projects {
		repos = append(repos, repo{
			gitUrl:    projectInfos.GitLink,
			projectID: projectInfos.Id,
			name:      projectInfos.Name,
		})
	}
	return
}

func wget(url string) (body []byte) {
	var resp *http.Response
	var err error
	resp, err = http.Get(url)

	if err != nil {
		log.Fatal(err)
	}

	body, err = io.ReadAll(resp.Body)
	resp.Body.Close()
	if resp.StatusCode > 299 {
		log.Fatalf("Response failed with status code: %d and\nbody: %s\n", resp.StatusCode, body)
	}
	if err != nil {
		log.Fatal(err)
	}
	return
}
