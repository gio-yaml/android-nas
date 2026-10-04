#!/data/data/com.termux/files/usr/bin/bash

set -e

echo "======================================"
echo "   SERVIDOR DE ARQUIVOS - TERMUX"
echo "======================================"
echo

echo "[1/5] Solicitando acesso aos arquivos..."
termux-setup-storage

echo
echo "Depois de permitir o acesso, pressione ENTER."
read -r

echo
echo "[2/5] Instalando dependências..."
echo
echo "Esta etapa pode demorar um pouco."
echo "O Python será instalado para detectar"
echo "automaticamente o IP do celular."
echo
echo "Também vamos adicionar o repositório TUR,"
echo "que fornece o File Browser nativo para Android."
echo

pkg install tur-repo python -y

if ! command -v python >/dev/null 2>&1; then
    echo
    echo "Não foi possível instalar o Python."
    exit 1
fi

echo
echo "[3/5] Instalando o File Browser..."
echo
echo "Usando o pacote nativo do Termux (TUR),"
echo "compatível com o Android."
echo

pkg install filebrowser -y

echo
echo "Verificando o File Browser..."

if ! filebrowser version; then
    echo
    echo "O File Browser foi instalado, mas não conseguiu executar."
    echo "Isso normalmente indica uma instalação incompleta."
    echo
    echo "Tente reinstalar com:"
    echo "  pkg install tur-repo filebrowser -y"
    exit 1
fi

echo
echo "✓ File Browser instalado!"
echo

echo
echo "[4/5] Configurando o servidor..."

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
echo "[5/5] Detectando o IP e iniciando o servidor..."
echo

# detecta o ip do celular pra mostrar automaticamente
IP=$(python -c "
import socket

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.connect(('8.8.8.8', 80))
print(s.getsockname()[0])
s.close()
" 2>/dev/null)

if [ -z "$IP" ]; then
    echo
    echo "Não foi possível detectar o IP do celular."
    echo
    exit 1
fi

echo "✓ IP detectado: $IP"

echo
echo "Iniciando servidor..."
echo

# inicia o file browser em segundo plano, imune ao encerramento do SSH
LOG="$HOME/.filebrowser/filebrowser.log"
PIDFILE="$HOME/.filebrowser/filebrowser.pid"

nohup filebrowser \
    -a 0.0.0.0 \
    -p "$PORT" \
    -r /storage/emulated/0 \
    -d "$DB" \
    >"$LOG" 2>&1 &

SERVER_PID=$!

# Aguarda o servidor iniciar
sleep 2

# verifica se o servidor continua rodando
if ! kill -0 "$SERVER_PID" 2>/dev/null; then
    echo
    echo "O servidor não conseguiu iniciar. Veja o log:"
    echo "  $LOG"
    exit 1
fi

# grava o PID para permitir parar o servidor depois
echo "$SERVER_PID" > "$PIDFILE"

echo
echo "======================================"
echo "       SERVIDOR INICIADO!"
echo "======================================"
echo
echo "Acesse pelo navegador:"
echo
echo "   http://$IP:$PORT"
echo
echo "Usuário: $USERNAME"
echo
echo "Certifique-se de que o outro dispositivo"
echo "está conectado à mesma rede Wi-Fi."
echo
echo "O servidor está rodando em segundo plano."
echo "Você pode fechar o Termux ou sair do SSH com segurança."
echo
echo "Para parar o servidor depois, rode:"
echo "  kill \$(cat ~/.filebrowser/filebrowser.pid)"
echo
echo "Para ver o log, rode:"
echo "  cat ~/.filebrowser/filebrowser.log"
