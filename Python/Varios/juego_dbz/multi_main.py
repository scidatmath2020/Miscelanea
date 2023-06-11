# -*- coding: utf-8 -*-
"""
Created on Thu Jun  8 18:21:39 2023

@author: Scidata
"""


import os
ruta_principal = "C:/Users/hp master/Documents/SciData/Miscelanea/Python/Otros/juego_dbz/" 
os.chdir(ruta_principal)

import pygame
from pygame import mixer
from mi_peleador import Peleador


'''personaje : [nombre,escala,offset,grito,hoja de movimientos,pasos de animación, izq/der]'''

personajes_1 = {
    "1":["Goku",
       2,
       [60,30],
       "activos/audio/goku.wav",
       "activos/imagenes/guerreros/goku.png",
       [10,4,1,5,12,4,7],1.2,1.5],
    
    "2":["Vegueta",
       2.5,
       [60,40],
       "activos/audio/vegueta.wav",
       "activos/imagenes/guerreros/vegeta.png",
       [8,5,1,7,9,4,7],1.2,1.5],
    "3":["Picoro",
       2.5,
       [60,40],
       "activos/audio/picoro.wav",
       "activos/imagenes/guerreros/picoro.png",
       [10,6,1,9,12,4,6],1.7,1.5]              
    }

personajes_2 = {
    "1":["Goku",
       2,
       [60,30],
       "activos/audio/goku.wav",
       "activos/imagenes/guerreros/goku.png",
       [10,4,1,5,12,4,7],1.2,1.5],
    
    "2":["Vegueta",
       2.5,
       [60,40],
       "activos/audio/vegueta.wav",
       "activos/imagenes/guerreros/vegeta.png",
       [8,5,1,7,9,4,7],1.2,1.5],
    "3":["Picoro",
       2.5,
       [60,40],
       "activos/audio/picoro.wav",
       "activos/imagenes/guerreros/picoro.png",
       [10,6,1,9,12,4,6],1.7,1.5]            
    }


escenarios = ["activos/imagenes/fondos/torneo.png",
              "activos/imagenes/fondos/tierra.png",
              "activos/imagenes/fondos/namekusei.png",
              "activos/imagenes/fondos/uam.png",
              "activos/imagenes/fondos/unam.png",
              "activos/imagenes/fondos/ipn.png",
              "activos/imagenes/fondos/buap.png"]

personaje1 = input("Selecciona personaje para jugador 1:\n1. Goku\n2. Vegueta\n3. Picoro\n")
per1 = personajes_1[personaje1]

personaje2 = input("Selecciona personaje para jugador 2:\n1. Goku\n2. Vegueta\n3. Picoro\n")
per2 = personajes_2[personaje2]

escenario = int(input("Elige escenario:\n1. Torneo de Artes Marciales\n2. Tierra\n3. Namekusei\n4. UAM\n5. UNAM\n6. IPN\n7. BUAP\n"))


mixer.init()
pygame.init()

    
'''Crear ventana del juego'''
VENTANA_ANCHO = 1200
VENTANA_ALTO = 600 

ventana = pygame.display.set_mode((VENTANA_ANCHO,VENTANA_ALTO))
pygame.display.set_caption("Dragon Ball Z de SciData")


'''Configurar frames por segundo'''
reloj = pygame.time.Clock()
FPS = 60

'''Variables del juego'''
contador_intro = 3
ultima_actualizacion_tiempo = pygame.time.get_ticks()
victorias = [0,0] #victorias[jugador1,jugador2]
round_finalizado = False
ROUND_FINALIZADO_RALENTIZADOR = 2000


'''perX: [nombre,escala,offset,grito,hoja de movimientos,pasos de animación, izq/der]'''
'''per1,per2'''

'''Definir las variables de los peleadores'''
jugador1_TAMANO = 162
jugador1_DATA = [jugador1_TAMANO,per1[1],per1[2]]

jugador2_TAMANO = 162
jugador2_DATA = [jugador2_TAMANO,per2[1],per2[2]]

pygame.mixer.music.load("activos/audio/dbz.wav")
pygame.mixer.music.set_volume(0.5)
pygame.mixer.music.play(-1, 0.0, 5000)

jugador1_grito = pygame.mixer.Sound(per1[3])
jugador1_grito.set_volume(0.5)
jugador2_grito = pygame.mixer.Sound(per2[3])
jugador2_grito.set_volume(0.5)

'''Cargar el escenario'''

# bg_image
escenario_imagen = pygame.image.load(escenarios[escenario-1]).convert_alpha() 

'''cargar imagenes de los peleadores'''

jugador1_hoja = pygame.image.load(per1[4]).convert_alpha() 
jugador2_hoja = pygame.image.load(per2[4]).convert_alpha() 

'''cargar imagen de victoria'''
imagen_victoria = pygame.image.load("C:\\Users\\hp master\\Documents\\SciData\\mi_juego\\juego\\assets\\images\\icons\\victory.png").convert_alpha()


'''Definir fuentes'''
contador_fuente = pygame.font.Font("C:\\Users\\hp master\\Documents\\SciData\\mi_juego\\juego\\assets\\fonts\\turok.ttf",80)
victorias_fuente = pygame.font.Font("C:\\Users\\hp master\\Documents\\SciData\\mi_juego\\juego\\assets\\fonts\\turok.ttf",30)

'''Función para añadir los textos'''
def dibujar_texto(texto,fuente,color_texto,x,y):
    img = fuente.render(texto,True,color_texto)
    ventana.blit(img,(x,y))
    

''' función para añadir el escenario a la ventana'''
def dibujar_escenario(): 
    escenario_escalado = pygame.transform.scale(escenario_imagen,(VENTANA_ANCHO,VENTANA_ALTO))
    ventana.blit(escenario_escalado,(0,0))

'''función para marcar las barras de salud'''
def dibujar_salud(salud,x,y):
    pygame.draw.rect(ventana,(255,255,255),(x-5,y-5,410,40))
    pygame.draw.rect(ventana,(255,0,0),(x,y,400,30))
    pygame.draw.rect(ventana,(255,255,0),(x,y,4*salud,30))


'''perX: [nombre,escala,offset,grito,hoja de movimientos,pasos de animación, izq/der]'''
'''per1,per2'''
    
'''Crear dos instancias de Peleador'''
peleador1 = Peleador(1,200,330,False,jugador1_DATA,jugador1_hoja,per1[5],jugador1_grito,per1[6],per1[7])
peleador2 = Peleador(2,900,330,True,jugador2_DATA,jugador2_hoja,per2[5],jugador2_grito,per2[6],per2[7])

''' Ciclo del juego '''

run = True
while run:
    reloj.tick(FPS)
    
    # dibujar escenario
    dibujar_escenario()
    
    # dibujar barras de salud
    dibujar_salud(peleador1.salud,120,20)
    dibujar_salud(peleador2.salud,680,20)
    dibujar_texto(f"{per1[0]}: {victorias[0]}", victorias_fuente, (128,0,0), 400, 50)
    dibujar_texto(f"{per2[0]}: {victorias[1]}", victorias_fuente, (128,0,0), 750, 50)
    
    
    # Actualizar cuenta regresiva
    if contador_intro <= 0:
        # Mover peleadores
        peleador1.movimientos(VENTANA_ANCHO,VENTANA_ALTO,ventana,peleador2,round_finalizado)
        peleador2.movimientos(VENTANA_ANCHO,VENTANA_ALTO,ventana,peleador1,round_finalizado)
    else:
        # mostrar contador_intro
        dibujar_texto(str(contador_intro), contador_fuente, (255,0,0), VENTANA_ANCHO/2, VENTANA_ALTO/3-100)
        #actualizar contador intro
        if pygame.time.get_ticks() - ultima_actualizacion_tiempo >= 1000:
            contador_intro = contador_intro - 1
            ultima_actualizacion_tiempo = pygame.time.get_ticks()
    
    
    # actualizar peleadores
    peleador1.actualizar()
    peleador2.actualizar()
    
    # dibujar peleadores
    peleador1.dibujar(ventana)
    peleador2.dibujar(ventana)
    
    
    # Revisar si un jugador ha perdido el round
    if round_finalizado == False:
        if peleador1.vivo == False:
            victorias[1] = victorias[1] + 1
            round_finalizado = True
            round_over_time = pygame.time.get_ticks()
        elif peleador2.vivo == False:
            victorias[0] = victorias[0] + 1
            round_finalizado = True
            round_over_time = pygame.time.get_ticks()
    else:
        # mostrar letrero de victoria
        ventana.blit(imagen_victoria,(VENTANA_ANCHO/2-150,VENTANA_ALTO/3-100))
        if pygame.time.get_ticks() - round_over_time > ROUND_FINALIZADO_RALENTIZADOR:
            round_finalizado = False
            contador_intro = 4
            peleador1 = Peleador(1,200,330,False,jugador1_DATA,jugador1_hoja,per1[5],jugador1_grito,per1[6],per1[7])
            peleador2 = Peleador(2,900,330,True,jugador2_DATA,jugador2_hoja,per2[5],jugador2_grito,per2[6],per2[7])                
    # controlador de eventos
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            run = False
    
    # actualizar pantalla
    pygame.display.update()
            
# salir de pygame
            
pygame.quit()

