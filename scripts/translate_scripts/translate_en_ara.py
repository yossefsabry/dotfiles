"""
➜  translate_scripts git:(main) ✗ python3 translate_en_ara.py "hello world"
Traceback (most recent call last):
  File "/home/yossef/dotfiles/scripts/translate_scripts/translate_en_ara.py", line 30, in <module>
    translated_text = argostranslate.translate.translate(input_text, from_code, to_code)
  File "/home/yossef/.local/lib/python3.10/site-packages/argostranslate/translate.py", line 683, in translate
    translation = get_translation_from_codes(from_code, to_code)
  File "/home/yossef/.local/lib/python3.10/site-packages/argostranslate/translate.py", line 669, in get_translation_from_codes
    return from_lang.get_translation(to_lang)
AttributeError: 'NoneType' object has no attribute 'get_translation'
Traceback (most recent call last):
  File "/home/yossef/dotfiles/scripts/translate_scripts/translate_en_ara.py", line 38, in <module>
    translated_text = argostranslate.translate.translate(input_text, from_code, to_code)
  File "/home/yossef/.local/lib/python3.10/site-packages/argostranslate/translate.py", line 683, in translate
    translation = get_translation_from_codes(from_code, to_code)
  File "/home/yossef/.local/lib/python3.10/site-packages/argostranslate/translate.py", line 669, in get_translation_from_codes
    return from_lang.get_translation(to_lang)
AttributeError: 'NoneType' object has no attribute 'get_translation'

not working this error how

"""







import sys
import argostranslate.package
import argostranslate.translate

# Ensure translation package is installed
from_code = "auto"  # Auto-detect source language
to_code = "ar"

# Update and install Arabic translation package
argostranslate.package.update_package_index()
available_packages = argostranslate.package.get_available_packages()
package_to_install = next(
    filter(
        lambda x: x.from_code == from_code and x.to_code == to_code,
        available_packages,
    ),
    None
)
if package_to_install:
    argostranslate.package.install_from_path(package_to_install.download())

# Get the input from command line arguments
if len(sys.argv) < 2:
    print("Usage: python translate_to_arabic.py 'your text here'")
    sys.exit(1)

input_text = " ".join(sys.argv[1:])

# Translate the input text
translated_text = argostranslate.translate.translate(input_text, from_code, to_code)

# Output the translation
print(translated_text)


