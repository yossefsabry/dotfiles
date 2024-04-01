module.exports = {
  "env": {
    "browser": true,
    "es2021": true,
    "node": true,
  },
  "extends": "plugin:react/recommended",
  "overrides": [
    {
      "env": {
        "node": true
      },
      "files": [
        ".eslintrc.{js,cjs}"
      ],
      "parserOptions": {
        "sourceType": "script",
        "ecmaVersion": 2020,
        "sourceType": "module",
        "source": "module"
      }
    }
  ],
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaVersion": "latest",
    "sourceType": "module"
  },
  "plugins": [
    "@typescript-eslint",
    "react"
  ],
  "rules": {
    'semi': 'warn',
    'no-alert': 'warn',
    'no-console': 'warn',
    'no-undef': 'warn',
    'no-unused-vars': 'warn'
  },
}
