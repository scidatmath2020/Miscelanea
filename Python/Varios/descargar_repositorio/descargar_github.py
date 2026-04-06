# -*- coding: utf-8 -*-
"""
Created on Mon Apr  6 02:18:57 2026

@author: SciData
"""

'''
Descarga toda una ruta de nuestro github y crea una carpeta en tu computadora
donde guarda lo descargado
'''
###############################################################################
###############################################################################
###############################################################################

### ruta para descargar

url_github = "https://github.com/scidatmath2020/............."

### lugar en tu computadora donde vas a descargar

ruta_local = r"............." + "\data"

###############################################################################
###############################################################################
###############################################################################


import os
import requests

def descargar_carpeta_github(url_carpeta, ruta_destino):
    """
    Descarga todos los archivos de una carpeta específica de GitHub
    """
    # Crear la carpeta destino si no existe
    os.makedirs(ruta_destino, exist_ok=True)
    
    # Convertir la URL de la carpeta a la API de GitHub
    api_url = url_carpeta.replace("github.com", "api.github.com/repos") \
                        .replace("/tree/main/", "/contents/")
    
    response = requests.get(api_url)
    if response.status_code != 200:
        print("Error al acceder a la carpeta:", response.status_code)
        return
    
    items = response.json()
    
    for item in items:
        if item['type'] == 'file':
            nombre_archivo = item['name']
            download_url = item['download_url']
            
            print(f"Descargando: {nombre_archivo}")
            
            file_response = requests.get(download_url)
            if file_response.status_code == 200:
                ruta_completa = os.path.join(ruta_destino, nombre_archivo)
                with open(ruta_completa, 'wb') as f:
                    f.write(file_response.content)
                print(f"✓ Guardado: {nombre_archivo}")
            else:
                print(f"✗ Error al descargar {nombre_archivo}")
        
        elif item['type'] == 'dir':
            # Si hay subcarpetas, las descargamos recursivamente
            print(f"→ Entrando en subcarpeta: {item['name']}")
            nueva_ruta = os.path.join(ruta_destino, item['name'])
            descargar_carpeta_github(item['html_url'], nueva_ruta)

# ==================== USO ====================

descargar_carpeta_github(url_github, ruta_local)

print("\n¡Descarga completada!")
