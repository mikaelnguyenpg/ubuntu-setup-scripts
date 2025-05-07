
## Installation

Overview: Main Steps

There are 5 main steps to go from zero to coding and running a Next.js TypeScript project in Helix:

    Install Helix and Dependencies
    Configure Helix for TypeScript, HTML, CSS, and SCSS
    Install Node.js and Required Tools
    Create a Next.js TypeScript Project
    Open and Run the Project in Helix

### Step 1: Install Helix and Dependencies

1. Install Helix:
```bash
sudo add-apt-repository ppa:maveonair/helix-editor
sudo apt update
sudo apt install helix
```
    This adds the Helix PPA and installs the latest version.

2. Fetch and Build Tree-sitter Grammars:
```bash
hx --grammar fetch
hx --grammar build
```
    Ensures syntax highlighting for TypeScript, HTML, CSS, and SCSS.

3. Verify Installation:
```bash
hx --version
```

### Step 2: Configure Helix for TypeScript, HTML, CSS, and SCSS

1. Create Configuration Files:

2. Configure languages.toml:


### Step 3: Install Node.js and Required Tools

1. Install Node.js:

2. Install Language Servers and Prettier:
```bash
sudo apt update
sudo apt install -y nodejs npm
sudo npm install -g typescript-language-server typescript vscode-langservers-extracted prettier emmet-ls
```

3. Verify Installations:

```bash
tsserver --version
prettier --version
emmet-ls --version
typescript-language-server --version
tailwindcss-language-server --version
vscode-html-language-server --version
vscode-css-language-server --version
vscode-json-language-server --version
```

4. Check Helix Health:

```bash
hx --health typescript
hx --health html
hx --health scss
hx --health css
hx --health json
```

### Step 4: Create a Next.js TypeScript Project

1. Create Project:

```bash
npx create-next-app@latest --ts my-nextjs-app
cd my-nextjs-app
```

2. Install SCSS Support:

```bash
npm install --save-dev sass
```

3. Test Project Setup:

```bash
npm run dev
```

4. Init tailwindcss

```bash
npx @tailwindcss/cli init
```

## Cheatsheet
[ref1](https://redoracle.com/Documents/Tutorials/helixCheatSheet.html)

