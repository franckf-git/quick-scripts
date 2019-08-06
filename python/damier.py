#!/usr/bin/python3
# -*- coding: utf8 -*-

# Copyright © 2018 Benoît Boudaud <https://twitter.com/Ordinosor>
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>

# TO DO LIST :
# Créer un bouton pour choisir la taille du damier 

 
from tkinter import *
 
class Damier(object):
    "Création du damier et des pions"
   
    def __init__(self, size = 80) :
        "Méthode constructeur"
        
        self.size = size

    def damier(self):
        "Création du damier"
        self.main_window = Tk()
        self.main_window.title("Jeu de dames")
        self.main_window.resizable(False, False)
 
        self.cadre_principal = Frame(self.main_window, bg = 'black')
        self.cadre_principal.grid()
        self.can = Canvas(self.cadre_principal, width = self.size*10,\
                   height = self.size*12, bg = "white")
        self.can.grid(row = 0, column = 0, columnspan = 2)
        self.can.bind("<Button-1>", self.test)
        for i in range(1, 10, 2) :
            for i2 in range(0, 10, 2):
                self.can.create_rectangle(self.size * i2, self.size * i,\
                self.size * (i2 + 1), self.size * (i + 1), width = 2,\
                fill = "black", state = 'disabled')
                self.can.create_rectangle(self.size * (i2 + 1),\
                self.size * (i + 1), self.size * (i2 + 2), self.size * (i + 2),\
                width = 2, fill = "black", state = 'disabled')
        self.can.create_rectangle(0, 0, self.size*10, self.size, width=4, fill='maroon')
        self.can.create_rectangle(0, (self.size+(self.size/10))*10, self.size*10,\
        (self.size+(self.size/10))*12, width=4, fill='ivory')
 
        self.creer_pions = Button(self.cadre_principal, text = "Nouvelle partie",\
                           bg = 'white', fg = 'black', font = ('Times', '14', 'bold'),\
                           relief = 'ridge', bd = 3, command = self.pions)
        self.creer_pions.grid(row = 1, column = 0, padx = 10, pady = 10, sticky = 'e')
		
        self.quitter = Button(self.cadre_principal, text = "Quitter",\
                        bg = 'white', fg = 'black', font = ('Times',\
                       '14', 'bold'), relief = 'ridge', bd = 3,\
                       command = self.main_window.destroy)
        self.quitter.grid(row = 1, column = 1, padx = 10, pady = 10, sticky = 'w')
 
        self.main_window.mainloop()
               
    def pions(self):
        "Création des pions"
        self.ajuster_pion = 5 if self.size <= 50 else 10
        for i in range(1, 10, 2) :
            self.color = 'maroon' if i >= 6 else 'ivory'
            for i2 in range(0, 10, 2):
                if i <= 3 or i >= 7 :
                    self.can.create_oval((self.size * i2) + self.ajuster_pion,\
                    (self.size * i) + self.ajuster_pion, (self.size * (i2 + 1))\
                    - self.ajuster_pion, (self.size * (i + 1)) - self.ajuster_pion,\
                    width = 2, fill = self.color)
                    self.can.create_oval((self.size * (i2 + 1)) + self.ajuster_pion,\

                   (self.size * (i + 1)) + self.ajuster_pion, (self.size * (i2 + 2))\
                   - self.ajuster_pion, (self.size * (i + 2)) - self.ajuster_pion,
                   width = 2, fill = self.color)
            self.pion = Deplacement(self.size, self.can)

    def test(self,event):
    	print(event.x, event.y)
        
class Deplacement(Damier):
    "Déplacement des pions"
    
    def __init__(self, size, can): 
        "Méthode constructeur"   
        Damier.__init__(self, size)
        self.can = can         
        self.can.bind("<Button-1>", self.catch_object)    
        self.can.bind("<Button1-Motion>", self.move_object)
        self.can.bind("<Button1-ButtonRelease>", self.leave)

    def catch_object(self, event):
        "clic gauche sur l'objet à déplacer"
        self.x1, self.y1 = event.x, event.y
        self.select_object = self.can.find_closest(self.x1, self.y1)
        if self.select_object[0] > 50 and self.select_object[0] < 100:
            self.can.lift(self.select_object)          



    def move_object(self, event):
        """Déplacement de l'objet en maintenant 
           le bouton gauche de la souris enfoncé"""
        x2, y2 = event.x, event.y
        dx, dy = x2 - self.x1 , y2 - self.y1
        if self.select_object[0] > 52 and self.select_object[0] < 100:
            self.can.move(self.select_object, dx, dy)
            self.x1, self.y1 = x2, y2

    def leave(self, event):
        """Objet déplacé, le joueur relâche
           le bouton gauche de la souris"""
        #self.t = self.can.coords(self.select_object, self.x2, self.y2, self.x3, self.y3)
        self.x2, self.y2, self.x3, self.y3 = 0, 70, 700, 140
        self.x4, self.y4, self.x5, self.y5 = 0, 700, 700, 770
        self.out_of_game_1 = self.can.find_enclosed(self.x2, self.y2, self.x3, self.y3)
        self.out_of_game_2 = self.can.find_enclosed(self.x4, self.y4, self.x5, self.y5)

        if self.select_object[0] > 52 and self.select_object[0] < 73 and self.out_of_game_2[len(self.out_of_game_2)-1] == self.select_object[0]:
            self.can.itemconfig(self.select_object, outline = "yellow", width=5)			
        if self.select_object[0] > 72 and self.select_object[0] < 93 and self.out_of_game_1[len(self.out_of_game_1)-1] == self.select_object[0]:
            self.can.itemconfig(self.select_object, outline = "yellow", width=5)
        if self.select_object:
            self.select_object = None
        

#======== Main Program =======================
size = 70
damier = Damier(size)
damier.damier()
