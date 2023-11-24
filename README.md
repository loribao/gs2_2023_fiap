#Confira o ip "*.*.*.*" e "1.1.1.1"
# Login Mundo linux
    - melhorando o acesso, para diminuir o stress.
```bash
sshpass -p "schoolofrock" ssh jackblack@1.1.1.1 -p 2003  -o "passwordAuthentication=yes"
```


# recursos auxiliares
    - Escrevendo uma função para base64 Decode em julia lang:
```julia 
using  Base64

decode = (encoded::String)-> base64decode(encoded) |> String

```    
# listando arquivos ocultos no home

``` bash
ls -la
```

# leitura dos arquivos ocultos com "CAT"

``` bash

cat .file.txt

cat .bash_history
```

# Descifrando ".file.txt"

# Deduções

- A flag é constituida por "FIAP"seguida de "{" então procurar codificações base64 que contenham o inicio "RklBUH" que equivale a palavra "FIAP" indica uma possivel flag. 

    - BASE64 = FIAP == RklBUH

- o acesso via SSH é sem vpn, logo o ip é publico 1.1.1.1

# Scan de serviços com NMAP

```bash
nmap 1.1.1.1
```
# Cod. utils
```julia
module utils    
    using  Base64
    using CodecBase
    export decode  
      
    decode =(encoded::String)->base64decode(encoded) |> String
    decode_base32=(encoded::String)->transcode(Base32Decoder(),encoded) |> String
end 
```
# Script de listagem do padrão FIAP em Base64
``` julia
try
    cmd_search_base64_fiap = Cmd(`sshpass -p "schoolofrock" 
                                  ssh jackblack@1.1.1.1 -p 2003
                                      -o "passwordAuthentication=yes" grep -r "RklBUH" /`)
    out_txt = "./dados/grep_RklBUH.txt"
    err_txt = "./dados/grep_RklBUH.txt"
    run(pipeline(cmd_search_base64_fiap,stdout=out_txt,stderr=err_txt))    
catch e
    println("Erro ao executar o comando: $e")
end

```