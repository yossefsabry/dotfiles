
module.exports = {
  "env": {
    "browser": true,
    "es2021": true,
    "node": true
  },
  "overrides": [
    {
      "files": [".eslintrc.js", ".eslintrc.cjs"],
      "env": { "node": true },
      "parserOptions": {
        "ecmaVersion": 2020,
        "sourceType": "module"
      }
    }
  ],
  "parserOptions": {
    "ecmaVersion": 2021,
    "sourceType": "module"
  },
  "rules": {
    "semi": "warn",
    "no-alert": "warn",
    "no-console": "off",
    "no-undef": "error",
    "no-unused-vars": "error",
    "comma-dangle": ["error", "never"]
  }
}
