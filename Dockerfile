FROM hearmeman/comfyui-wan-template:v28

COPY template.json /comfyui-wan/template.json
COPY models_registry.json /comfyui-wan/src/models_registry.json
COPY pins.json /comfyui-wan/pins.json

RUN mkdir -p "/comfyui-wan/workflows/AI VIDGEN"

COPY workflows/Wan2.2_I2V.json \
     "/comfyui-wan/workflows/AI VIDGEN/Wan2.2_I2V.json"

