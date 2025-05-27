# aplicativo_receitas
 
# 🍽 Aplicativo de Receitas

Aplicativo Flutter para cadastrar, listar, editar e remover receitas culinárias, com gerenciamento de dados em memória utilizando Provider.

## 📱 Funcionalidades

- Cadastro de usuários
- Login e Logout
- Editar dados de usuário
- Redefinir senha
- Excluir perfil
- Adicionar nova receita
- Listar todas as receitas
- Favoritar receita

## 🐛 Bugs

- Travamento ao escolher imagem
- overflow ao editar usuário
- Erro ao carregar receitas ao delogar e logar novamente

## 📵 Funcionalidades faltantes

- exibição de imagem
- integração a API

## 📦 Instalação e execução

### Pré-requisitos

- [Flutter instalado](https://docs.flutter.dev/get-started/install)
- Um editor como [VSCode](https://code.visualstudio.com/) ou [Android Studio](https://developer.android.com/studio)
- conta no Firebase

### Passos

### 🔧 Passos para instalar o projeto e configurar o Firebase

1. **Clone o repositório**

    ```bash
    git clone https://github.com/seu-usuario/aplicativo_receitas.git
    ```

2. **Acesse a pasta do projeto**

    ```bash
    cd aplicativo_receitas
    ```

3. **Instale as dependências do Flutter**

    ```bash
    flutter pub get
    ```

4. **Configure o Firebase**

   #### a) Crie um projeto no [Firebase Console](https://console.firebase.google.com/)

   #### b) Adicione um app Android:
   - Nome do pacote (copie do `android/app/src/main/AndroidManifest.xml`), ex: `com.example.aplicativo_receitas`
   - Baixe o arquivo `google-services.json`
   - Mova para:  
     ```
     android/app/google-services.json
     ```

   #### c) Atualize os arquivos do Android:

   - Em `android/build.gradle`:
     ```gradle
     dependencies {
       classpath 'com.google.gms:google-services:4.3.15'
     }
     ```

   - Em `android/app/build.gradle`:
     ```gradle
     apply plugin: 'com.google.gms.google-services'
     ```

5. **Adicione os pacotes Firebase no `pubspec.yaml`**

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      firebase_core: ^2.25.4
      firebase_auth: ^4.17.6
      cloud_firestore: ^4.15.6
      # firebase_storage: ^11.6.6 (se usar upload de imagens)
      # outros pacotes que seu app usar
    ```

    Depois, execute:

    ```bash
    flutter pub get
    ```

6. **Inicialize o Firebase no `main.dart`**

    ```dart
    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      runApp(MeuAplicativo());
    }
    ```

7. **Execute o projeto**

    ```bash
    flutter run
    ```

    Certifique-se de ter um emulador aberto ou dispositivo físico conectado.
"""

# Caminho para salvar o arquivo
readme_path = Path("/mnt/data/README.md")

# Salvar o conteúdo no arquivo
readme_path.write_text(readme_content, encoding="utf-8")

