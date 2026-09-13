# 📱 Servidor de arquivos usando um celular velho

Transformando um celular Android em um **servidor de arquivos acessível pelo Wi-Fi**.

**celular velho → Termux → File Browser → seus arquivos pela rede**

A ideia é reaproveitar um celular que está parado e transformar ele em uma espécie de mini drive, sem precisar de computador ou hardware dedicado.

Depois de criar o servidor na rede local, também é possível configurar um acesso pela internet.

---

## O que esse script faz?

Você baixa o projeto, roda o instalador e ele cuida do resto:

* libera o acesso aos arquivos do Android
* instala as dependências necessárias
* detecta a arquitetura do celular
* baixa a versão correspondente do File Browser
* instala o File Browser
* permite criar seu próprio usuário
* permite criar sua própria senha
* exige uma senha com no mínimo 12 caracteres
* permite escolher a porta do servidor
* detecta automaticamente o IP do celular
* inicia o servidor

A porta padrão é **8080**, mas você pode escolher outra durante a instalação.

---

## O que você precisa

* um celular Android
* Wi-Fi
* Termux

> O celular e o dispositivo que vai acessar os arquivos precisam estar na mesma rede Wi-Fi.

Não é necessário:

* root
* modo desenvolvedor
* depuração USB
* conectar o celular ao computador

---

## Instalação

### 1. Instale o Termux

Recomendo instalar pela versão disponível no F-Droid:

https://f-droid.org/packages/com.termux/

Depois abra o Termux.

### 2. Baixe o projeto

Primeiro instale o Git:

```bash
pkg update
```

```bash
pkg install git -y
```

Agora baixe este repositório:

```bash
git clone https://github.com/gio-yaml/android-nas
```

Entre na pasta:

```bash
cd android-nas
```

E rode o instalador:

```bash
bash install.sh
```

A partir daqui, o script vai guiando você.

---

## Login

Durante a instalação, você poderá criar seu próprio usuário e senha.

```text
Digite o nome de usuário:
Digite sua senha:
Digite a senha novamente:
```

A senha não aparece enquanto você digita. Isso é normal.

A senha precisa ter **no mínimo 12 caracteres**.

Se as senhas não forem iguais, o instalador pede para tentar novamente.

---

## Escolhendo a porta

O instalador também permite escolher a porta que será usada pelo servidor.

Por padrão:

```text
Digite a porta [8080]:
```

Se você apertar `ENTER`, será utilizada a porta:

```text
8080
```

Mas você pode escolher outra:

```text
Digite a porta [8080]: 8085
```

Nesse caso, o endereço será:

```text
http://IP-DO-CELULAR:8085
```

---

## Acessando os arquivos

Depois da configuração, o script detecta automaticamente o IP do celular e mostra o endereço para acessar o servidor.

Algo como:

```text
======================================
       SERVIDOR INICIADO!
======================================

Acesse pelo navegador:

   http://192.168.15.31:8080

Usuário: seu_usuario

Certifique-se de que o outro dispositivo
está conectado à mesma rede Wi-Fi.
```

É só copiar o endereço mostrado no Termux e abrir no navegador do computador ou de outro celular conectado à mesma rede.

Depois, faça login usando o usuário e a senha que você criou.

---

## Arquiteturas

O instalador verifica automaticamente a arquitetura do celular usando `uname -m`.

Atualmente são consideradas:

```text
aarch64  → ARM64
x86_64   → AMD64
i686     → x86 32-bit
armv7l   → ARM 32-bit
```

A maioria dos celulares Android atuais usa ARM64 e deve retornar:

```text
aarch64
```

Se a arquitetura não for reconhecida pelo script, a instalação é interrompida


## Usando como um mini NAS

Depois de instalado, você pode deixar o celular conectado ao Wi-Fi e usar o servidor para:

* armazenar arquivos
* transferir arquivos entre dispositivos
* guardar fotos e vídeos
* fazer backups
* acessar documentos
* reaproveitar um celular antigo

Basicamente, aquele celular parado na gaveta ganha uma segunda vida!

---

## Acesso pela internet

Por padrão, o servidor foi pensado para funcionar dentro da sua **rede local**.

É possível fazer o acesso pela internet, mas com uma configuração adicional de rede e segurança.

**Não abra simplesmente a porta do File Browser no roteador sem entender o que está fazendo.**

---

Se esse projeto te ajudou, uma estrela no repositório já ajuda bastante. ⭐

**gio.yaml**
