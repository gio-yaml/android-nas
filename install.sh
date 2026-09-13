#!/data/data/com.termux/files/usr/bin/bash

set -e

echo "======================================"
echo "   SERVIDOR DE ARQUIVOS - TERMUX"
echo "======================================"
echo

echo "[1/7] Solicitando acesso aos arquivos..."
termux-setup-storage

echo
echo "Depois de permitir o acesso, pressione ENTER."
read -r

echo
echo "[3/7] Instalando dependências..."
pkg install wget tar -y

echo
echo "[4/7] Detectando arquitetura..."

ARCH=$(uname -m)

case "$ARCH" in
    aarch64)
        FILE="linux-arm64-filebrowser.tar.gz"
        echo "✓ ARM64 detectado (aarch64)"
        ;;
    x86_64)
        FILE="linux-amd64-filebrowser.tar.gz"
        echo "✓ AMD64 detectado (x86_64)"
        ;;
    i686|x86)
        FILE="linux-386-filebrowser.tar.gz"
        echo "✓ x86 32-bit detectado"
        ;;
    armv7l|arm)
        FILE="linux-armv5-filebrowser.tar.gz"
        echo "✓ ARM 32-bit detectado"
        echo "Usando a build ARMv5."
        ;;
    *)
        echo
        echo "Arquitetura não suportada: $ARCH"
        exit 1
        ;;
esac

echo
echo "[5/7] Baixando File Browser..."

cd "$HOME"

rm -f "$FILE"

wget -q --show-progress \
"https://github.com/filebrowser/filebrowser/releases/latest/download/$FILE"

echo
echo "Extraindo File Browser..."

tar -xzf "$FILE"

echo "Instalando File Browser..."

mv -f filebrowser "$PREFIX/bin/filebrowser"

chmod +x "$PREFIX/bin/filebrowser"

rm -f "$FILE"

echo
echo "✓ File Browser instalado!"

if ! command -v filebrowser >/dev/null 2>&1; then
    echo "Não foi possível encontrar o File Browser :("
    exit 1
fi

echo
filebrowser version

echo
echo "[6/7] Configurando o servidor..."

mkdir -p "$HOME/.filebrowser"

DB="$HOME/.filebrowser/filebrowser.db"

if [ ! -f "$DB" ]; then
    filebrowser -d "$DB" config init
fi

echo
echo "======================================"
echo "       CRIAR LOGIN DO SERVIDOR"
echo "======================================"
echo

while true; do
    read -rp "Digite o nome de usuário: " USERNAME

    if [ -n "$USERNAME" ]; then
        break
    fi

    echo "O usuário não pode ficar vazio."
done

while true; do
    read -rsp "Digite sua senha: " PASSWORD
    echo

    if [ -z "$PASSWORD" ]; then
        echo "A senha não pode ficar vazia."
        echo
        continue
    fi

    if [[ ${#PASSWORD} -lt 12 ]]; then
        echo "A senha precisa ter no mínimo 12 caracteres."
        echo
        continue
    fi

    read -rsp "Digite a senha novamente: " PASSWORD2
    echo

    if [ "$PASSWORD" = "$PASSWORD2" ]; then
        break
    fi

    echo "As senhas não coincidem."
    echo
done

filebrowser -d "$DB" users add "$USERNAME" "$PASSWORD" --perm.admin

echo
echo "======================================"
echo "       CONFIGURAÇÃO DA PORTA"
echo "======================================"
echo

echo "A porta padrão é 8080."
echo "Pressione ENTER para usar 8080."
echo

while true; do
    read -rp "Digite a porta [8080]: " PORT

    PORT=${PORT:-8080}

    if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
        echo "Digite apenas números."
        continue
    fi

    if [ "$PORT" -lt 1024 ] || [ "$PORT" -gt 65535 ]; then
        echo "Escolha uma porta entre 1024 e 65535."
        continue
    fi

    break
done

echo
echo "✓ Porta escolhida: $PORT"

echo
echo "======================================"
echo "       INSTALAÇÃO CONCLUÍDA!"
echo "======================================"
echo

echo "Usuário: $USERNAME"
echo "Porta: $PORT"

echo
echo "Iniciando servidor..."
echo

# Detectar IP local do celular
IP=""

for interface in $(ip -o link show | awk -F': ' '{print $2}' | cut -d'@' -f1); do

    ADDRESSES=$(ip -4 addr show "$interface" 2>/dev/null | \
        awk '/inet / {print $2}' | cut -d/ -f1)

    for addr in $ADDRESSES; do

        # Ignorar localhost
        if [[ "$addr" == "127."* ]]; then
            continue
        fi

        # Rede 10.x.x.x
        if [[ "$addr" =~ ^10\. ]]; then
            IP="$addr"
            break 2
        fi

        # Rede 192.168.x.x
        if [[ "$addr" =~ ^192\.168\. ]]; then
            IP="$addr"
            break 2
        fi

        # Rede 172.16.x.x até 172.31.x.x
        if [[ "$addr" =~ ^172\.(1[6-9]|2[0-9]|3[0-1])\. ]]; then
            IP="$addr"
            break 2
        fi

    done
done

# Iniciar File Browser
filebrowser \
    -a 0.0.0.0 \
    -p "$PORT" \
    -r /storage/emulated/0 \
    -d "$DB" &

SERVER_PID=$!

# Aguardar o servidor iniciar
sleep 2

echo
echo "======================================"
echo "       SERVIDOR INICIADO!"
echo "======================================"
echo

if [ -n "$IP" ]; then
    echo "Acesse:"
    echo
    echo "   http://$IP:$PORT"
    echo
else
    echo "Não foi possível detectar o IP do celular."
    echo "Use o IP do celular com a porta $PORT."
    echo
fi

echo "Servidor rodando."
echo "Pressione CTRL+C para encerrar."
echo

# Manter o processo ativo
wait "$SERVER_PID"