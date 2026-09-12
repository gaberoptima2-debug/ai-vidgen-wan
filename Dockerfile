FROM hearmeman/comfyui-wan-template:v28

RUN rm -rf /ai-vidgen-template \
    && mkdir -p "/ai-vidgen-template/src" \
    && mkdir -p "/ai-vidgen-template/workflows/AI VIDGEN"

COPY template.json /ai-vidgen-template/template.json
COPY pins.json /ai-vidgen-template/pins.json
COPY models_registry.json /ai-vidgen-template/src/models_registry.json

COPY ["workflows/AI VIDGEN/Wan2.2_I2V.json", "/ai-vidgen-template/workflows/AI VIDGEN/Wan2.2_I2V.json"]

COPY start_script_ai_vidgen.sh /start_script.sh
RUN chmod +x /start_script.sh
