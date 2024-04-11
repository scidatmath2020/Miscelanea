texto = readline("Ingresa un texto: ")

i = 1
while(TRUE){
  caracter = substr(texto,i,i)
  if(caracter != ""){
    print(caracter)
    i = i+1}
  else{
    break
  }
}

print(paste0("El total de caracteres del texto '",texto,"' es ",i-1))