# dall_e_generate_and_download

Generate an image from the OpenAI service given a prompt and image size.

Requires the OpenAI API key to be stored in a text file named `api.key`

This example will generate an image named `prompt_text_.png` with 256 pixels on each side.

    generate_image.sh 'prompt text' 256x256
    
The usefulness of this script is that it provides an easy way of querying the OpenAI API and downloading the resulting file to a human readable filename.

