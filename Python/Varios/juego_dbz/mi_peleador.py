# -*- coding: utf-8 -*-
"""
Created on Mon Jun  5 22:22:20 2023

@author: Scidata
"""

import pygame

class Peleador():
    def __init__(self,jugador,x,y,giro,data,peleador_hoja,animacion_pasos,sonido,alcance1,alcance2):
        self.jugador = jugador
        self.tamano = data[0]
        self.imagen_escalada = data[1]
        self.offset = data[2]
        self.girar = giro
        self.animacion_lista = self.cargar_imagen(peleador_hoja,animacion_pasos)
        self.accion = 0 # 0:inactivo, 1:correr, 2:saltar, 3:ataque1, 4:ataque2, 5:golpe, 6:muerto
        self.indice_frame = 0
        self.imagen = self.animacion_lista[self.accion][self.indice_frame]
        self.actualizar_tiempo = pygame.time.get_ticks()
        self.rect = pygame.Rect((x,y,100,180))
        self.vel_y = 0
        self.corriendo = False
        self.saltando = False 
        self.atacando = False
        self.ataque_tipo = 0
        self.alcance_ataque1 = alcance1
        self.alcance_ataque2 = alcance2
        self.ataque_ralentizador = 0
        self.ataque_sonido = sonido
        self.hit = False
        self.salud = 100
        self.vivo = True
        
    def cargar_imagen(self,peleador_hoja,animacion_pasos):
        # Extraer imagenes desde la hoja del peleador
        animacion_lista = []
        for y, animacion in enumerate(animacion_pasos):
            imagen_temporal_lista = []
            for x in range(animacion):
                imagen_temporal = peleador_hoja.subsurface(x*self.tamano,y*self.tamano,self.tamano,self.tamano)
                imagen_temporal_lista.append(pygame.transform.scale(imagen_temporal,(self.tamano*self.imagen_escalada,self.tamano*self.imagen_escalada)))
            animacion_lista.append(imagen_temporal_lista)
        return animacion_lista
        
        
        
    def movimientos(self,ventana_ancho,ventana_alto,superficie,objetivo,round_over):
        VELOCIDAD = 10
        dx = 0
        dy = 0
        GRAVEDAD = 2
        self.corriendo = False
        self.ataque_tipo = 0
        
        # Reconocer teclas oprimidas
        tecla = pygame.key.get_pressed()
        
        # Solo se puede mover si no está ejecutando un ataque
        if self.atacando == False and self.vivo == True and round_over == False:
            # Controles del jugador 1
            if self.jugador == 1:
                # movimiento horizontal
                if tecla[pygame.K_a]:
                    dx = -VELOCIDAD
                    self.corriendo = True
                if tecla[pygame.K_d]:
                    dx = VELOCIDAD
                    self.corriendo = True
                
                # Saltos
                if tecla[pygame.K_w] and self.saltando == False:
                    self.vel_y = -30
                    self.saltando = True
                
                # Ataques
                if tecla[pygame.K_r] or tecla[pygame.K_t]:
                    # Determinar el tipo de ataque
                    if tecla[pygame.K_r]:
                        self.ataque_tipo = 1
                    if tecla[pygame.K_t]:
                        self.ataque_tipo = 2
                    self.ataque(superficie,objetivo)
                    
            # Controles del jugador 2
            if self.jugador == 2:
                # movimiento horizontal
                if tecla[pygame.K_LEFT]:
                    dx = -VELOCIDAD
                    self.corriendo = True
                if tecla[pygame.K_RIGHT]:
                    dx = VELOCIDAD
                    self.corriendo = True
                
                # Saltos
                if tecla[pygame.K_UP] and self.saltando == False:
                    self.vel_y = -30
                    self.saltando = True
                
                # Ataques #KP1, KP2
                if tecla[pygame.K_KP1] or tecla[pygame.K_KP2]:
                    # Determinar el tipo de ataque
                    if tecla[pygame.K_KP1]:
                        self.ataque_tipo = 1
                    if tecla[pygame.K_KP2]:
                        self.ataque_tipo = 2
                    self.ataque(superficie,objetivo)
        
                
        
        # Aplicar gravedad
        self.vel_y = self.vel_y + GRAVEDAD
        dy = dy + self.vel_y
        
        # Mantener a los peleadores dentro de la ventana
        if self.rect.left + dx < 0:
            dx = -self.rect.left 
        if self.rect.right + dx > ventana_ancho:
            dx = ventana_ancho - self.rect.right
        if self.rect.bottom + dy > ventana_alto - 90:
            self.vel_y = 0
            self.saltando = False
            dy = ventana_alto -90- self.rect.bottom
        
        # Aegurarse de que los peleadores están frente a frente
        if objetivo.rect.centerx > self.rect.centerx:
            self.girar = False
        else:
            self.girar = True
        
        # aplicar ralentizador de ataque
        if self.ataque_ralentizador > 0:
            self.ataque_ralentizador = self.ataque_ralentizador - 1
        
        
        # Actualizar posición del peleador
        self.rect.x = self.rect.x + dx
        self.rect.y = self.rect.y + dy
    
    def actualizar(self):
        # Revisar qué acción esta realizando
        if self.salud <= 0:
            self.salud = 0
            self.vivo = False
            self.actualizar_accion(6)
        elif self.hit == True:
            self.actualizar_accion(5)
        elif self.atacando == True:
            if self.ataque_tipo == 1:
                self.actualizar_accion(3)
            elif self.ataque_tipo == 2:
                self.actualizar_accion(4)
        elif self.saltando == True:
            self.actualizar_accion(2)
        elif self.corriendo == True:
            self.actualizar_accion(1)
        else:
            self.actualizar_accion(0)
            
        animacion_temporizador = 50
        self.imagen = self.animacion_lista[self.accion][self.indice_frame]
        if pygame.time.get_ticks()-self.actualizar_tiempo > animacion_temporizador:
            self.indice_frame = self.indice_frame + 1
            self.actualizar_tiempo = pygame.time.get_ticks()
        
        # revisar si la animación ha finalizado
        if self.indice_frame >= len(self.animacion_lista[self.accion]):
            # revisar si el jugador está muerto
            if self.vivo == False:
                self.indice_frame = len(self.animacion_lista[self.accion]) - 1
            else:
                self.indice_frame = 0
                if self.accion == 3 or self.accion == 4:
                    self.atacando = False
                    self.ataque_ralentizador = 20
            # revisar si se ha realizado un daño
                if self.accion == 5:
                    self.hit = False
                    self.atacando = False
                    self.ataque_ralentizador = 50
    
    def ataque(self,superficie,objetivo):
        if self.ataque_ralentizador == 0:
            self.atacando = True
            self.ataque_sonido.play()
            if self.ataque_tipo == 1:
                alcance = self.alcance_ataque1
                danio = 5
            elif self.ataque_tipo == 2:
                alcance = self.alcance_ataque2
                danio = 10
            
            rectangulo_ataque = pygame.Rect(self.rect.centerx - (alcance*self.rect.width*self.girar),self.rect.y,alcance*self.rect.width,self.rect.height)
            if rectangulo_ataque.colliderect(objetivo.rect):
                objetivo.salud = objetivo.salud - danio
                objetivo.hit = True
         
    def actualizar_accion(self,nueva_accion):
        # revisar si la acción nueva es igual a la anterior
        if nueva_accion != self.accion:
            self.accion = nueva_accion
            #actualizar la configuración de la animación
            self.indice_frame = 0
            self.actualizar_tiempo = pygame.time.get_ticks()
    
    def dibujar(self, superficie):
        img = pygame.transform.flip(self.imagen, self.girar,False)
        #pygame.draw.rect(superficie,(255,0,0),self.rect)
        superficie.blit(img,(self.rect.x - (self.offset[0]*self.imagen_escalada),self.rect.y - (self.offset[1]*self.imagen_escalada)))
    
    