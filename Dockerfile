FROM git.lerch.org/lobo/xuantie-gnu-toolchain:b181cea

# Might be easier to pull down the tar.gz instead...

ADD https://github.com/bouffalolab/bouffalo_sdk/archive/2f6477f7e8882a01b4c8651d4676de2a3fa33c76.tar.gz /

ADD https://git.lerch.org/lobo/blflashcommand/archive/2cbf382b74e6549d8cafe0db0813db7f285ff781.tar.gz /

ADD https://github.com/Fishwaldo/bflb_fw_post_proc/archive/ca6f32b077d2e6bfa5ec64f872482b2baba38e78.tar.gz /

RUN true && \
    tar xzf 2f6477f7e8882a01b4c8651d4676de2a3fa33c76.tar.gz && \
    mv bouffalo_sdk-2f6477f7e8882a01b4c8651d4676de2a3fa33c76 bouffalo_sdk && \
    rm 2f6477f7e8882a01b4c8651d4676de2a3fa33c76.tar.gz && \
    tar xzf 2cbf382b74e6549d8cafe0db0813db7f285ff781.tar.gz && \
    rm 2cbf382b74e6549d8cafe0db0813db7f285ff781.tar.gz && \
    tar xzf ca6f32b077d2e6bfa5ec64f872482b2baba38e78.tar.gz && \
    mv bflb_fw_post_proc-ca6f32b077d2e6bfa5ec64f872482b2baba38e78 bflb_fw_post_proc && \
    rm ca6f32b077d2e6bfa5ec64f872482b2baba38e78.tar.gz && \
    rm -r bouffalo_sdk/examples && \
    rm -r bouffalo_sdk/docs && \
    cp bouffalo_sdk/tools/vscode/c_cpp_properties.json bouffalo_sdk && \
    rm -r bouffalo_sdk/tools && \
    sed -i 's#..BL_SDK_BASE./tools/cmake/bin/##g' /bouffalo_sdk/project.build && \
    sed -i 's#/tools/vscode##g' /bouffalo_sdk/cmake/gen_c_cpp_properties_json.cmake && \
    sed -i 's#..BL_SDK_BASE./tools/bflb_tools/bflb_fw_post_proc/bflb_fw_post_proc..TOOL_SUFFIX.#python3 /bflb_fw_post_proc/bflb_fw_post_proc.py#g' /bouffalo_sdk/cmake/bflb_flash.cmake && \
    sed -i 's#..BL_SDK_BASE./tools/bflb_tools/bouffalo_flash_cube/BLFlashCommand-ubuntu#python3 /blflashcommand/BLFlashCommand.py#g' /bouffalo_sdk/project.build && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      python3 \
      python3-pip \
      && \
    apt-get install -y gcc && \
    pip3 install --break-system-packages bflb_mcu_tool && \
    pip3 install --break-system-packages -r blflashcommand/requirements.txt && \
    apt-get remove -y --autoremove gcc && \
    apt-get clean && \
    true

env BL_SDK_BASE=/bouffalo_sdk

COPY entrypoint /entrypoint

ENTRYPOINT [ "/entrypoint" ]

# NOTE: Still binary blobs for wifi, ble
