# 📱 Servidor de arquivos usando um celular velho

Transformando um celular android em um **servidor de arquivos acessível pelo Wi-Fi**.


**celular velho → Termux → File Browser → seus arquivos pela rede**

(Depois de criar ele acessível pela rede, também é possível fazer ele ficar acessível pela internet)

---

## ✨ O que esse script faz?

Você roda **um comando** no Termux e ele:

* libera o acesso aos arquivos do Android
* atualiza o Termux
* detecta a arquitetura do celular
* baixa a versão correspondente do File Browser
* instala o File Browser
* deixa você escolher usuário e senha
* deixa você escolher a porta
* inicia o servidor

A porta padrão é **8080**, mas você pode escolher outra.

---

## O que você precisa

* um celular Android
* Wi-Fi
* Termux

> O celular e o dispositivo que vai acessar os arquivos precisam estar na mesma rede Wi-Fi.

---

## Instalação

### 1. Instale o Termux

Recomendo instalar pela versão disponível no F-Droid:

https://f-droid.org/packages/com.termux/

Depois abra o Termux.

### 2. Rode o instalador

```bash
pkg update
```

```bash
pkg install git -y
```

```bash
git clone https://github.com/gio-yaml/android-nas
```

```bash
cd android-nas
```

```bash
bash install.sh
```

E pronto. O script vai guiando você durante a instalação.

---

## Login

Durante a instalação, você escolhe:

```text
Usuário:
Senha:
```

A senha não aparece na tela enquanto você digita. É normal.

Depois o File Browser fica protegido pelo login que você criou.

---

## Escolhendo a porta

O instalador pergunta:

```text
Digite a porta [8080]:
```

Se você simplesmente apertar **ENTER**, ele usa:

```text
8080
```

Mas você pode escolher outra:

```text
Digite a porta [8080]: 8085
```

Nesse caso, o servidor ficará em:

```text
http://IP-DO-CELULAR:8085
```

---

## Acessando os arquivos

Depois que o servidor iniciar, você verá algo parecido com:

```text
Server started
```

Descubra o IP do celular nas configurações do Wi-Fi.

Por exemplo:

```text
192.168.15.31
```

No computador, abra:

```text
http://192.168.15.31:8080
```

Se você escolheu outra porta, use ela no final.

Exemplo:

```text
http://192.168.15.31:8085
```

Faça login com o usuário e a senha que você criou.

Agora você consegue acessar os arquivos do celular pelo navegador. 👀

---

## Arquiteturas

O script tenta detectar automaticamente a arquitetura do aparelho.

```text
aarch64  → ARM64
x86_64   → AMD64
i686     → x86 32-bit
armv7l   → ARM 32-bit
```

A maioria dos celulares Android atuais deve retornar:

```text
aarch64
```

---

## Rodando manualmente

Se você precisar iniciar o servidor novamente depois:

```bash
filebrowser -a 0.0.0.0 -p 8080 -r /storage/emulated/0
```

Se estiver usando outra porta:

```bash
filebrowser -a 0.0.0.0 -p 8085 -r /storage/emulated/0
```

---

Agora é só deixar o celular sempre ligado e funcionando como um servidor!

---

## Sobre o File Browser

Este projeto utiliza o [File Browser](https://github.com/filebrowser/filebrowser) para fornecer a interface de gerenciamento dos arquivos.

---

Se esse projeto te ajudou, ⭐ no repositório :) 
