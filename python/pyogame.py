#! /bin/python
#script for pyogame https://github.com/alaingilbert/pyogame
#install lib with sudo pip install ogame

from __future__ import print_function
from ogame import OGame
from ogame.constants import Ships, Speed, Missions, Buildings, Research, Defense

USER=''
PASS=''
UNIV=''

ogame = OGame(UNIV, USER, PASS, domain="fr.ogame.gameforge.com/#login")

# print(ogame.get_server_time())
# print("\n")
print("I am under attack ?")
print(ogame.is_under_attack())

#print("The planets are :")
planet=ogame.get_planet_ids()
colonie1=ogame.get_planet_by_name("Colonie 1")
#print("Colonie 1", colonie1)
colonie2=ogame.get_planet_by_name("Colonie 2")
#print("Colonie 2", colonie2)
colonie3=ogame.get_planet_by_name("Colonie 3")
#print("Colonie 3", colonie3)
colonie4=ogame.get_planet_by_name("Colonie 4")
#print("Colonie 4", colonie4)
colonie5=ogame.get_planet_by_name("Colonie 5")
#print("Colonie 5", colonie5)
colonie6=ogame.get_planet_by_name("Colonie 6")
#print("Colonie 6", colonie6)
colonie7=ogame.get_planet_by_name("Colonie 7")
#print("Colonie 7", colonie7)
#print("\n")

#ogame.build(colonie7, Buildings['SolarPlant'])

expedition=[colonie2,colonie3,colonie4]
transport=[colonie1,colonie2,colonie3,colonie4,colonie5,colonie6,colonie7]
transportcible=colonie7
localisation=ogame.get_planet_infos(transportcible)
localisationtransportcible=localisation['coordinate']

fleetinprogress=ogame.fetch_eventbox()
print("The next fleet is:")
for key,val in fleetinprogress.items():
    print(key, "=>", val)

#for i in planet:
#    print(i)
#    ships=ogame.get_ships(i)
#    ressources=ogame.get_resources(i)
#    for key,val in ships.items():
#        print(key, "=>", val)
#    print("\n")
#    for key,val in ressources.items():
#        print(key, "=>", val)
#    print("\n")

print("Launch expeditions with id:")
for i in expedition:
    print("For planet :")
    print(i)
    print("Launch expeditions :")
    expeditionships = [(Ships['LightFighter'], 1000), (Ships['HeavyFighter'], 1000), (Ships['Cruiser'], 1000), (Ships['SmallCargo'], 1000)]
    expeditionspeed = Speed['100%']
    expeditionwhere = {'galaxy': 4, 'system': 86, 'position': 16}
    expeditionmission = Missions['Expedition']
    expeditionresources = {'metal': 0, 'crystal': 0, 'deuterium': 0}
    ogame.send_fleet(i, expeditionships, expeditionspeed, expeditionwhere, expeditionmission, expeditionresources)
    print(ogame.send_fleet(i, expeditionships, expeditionspeed, expeditionwhere, expeditionmission, expeditionresources))
print("\n")

print("Launch transports with id:")
for i in transport:
    print("For planet :")
    print(i)
    print("Launch transport :")
    transportships = [(Ships['LargeCargo'], 1000)]
    transportspeed = Speed['100%']
    transportwhere = localisationtransportcible
    transportmission = Missions['Transport']
    transportresources = {'metal': 10000000, 'crystal': 10000000, 'deuterium': 10000000}
    ogame.send_fleet(i, transportships, transportspeed, transportwhere, transportmission, transportresources)
    print(ogame.send_fleet(i, transportships, transportspeed, transportwhere, transportmission, transportresources))
print("\n")
