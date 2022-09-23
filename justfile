gen:
    flutter_rust_bridge_codegen \
        --rust-input rust/src/api.rs \
        --rust-output rust/src/bridge_generated/api.rs \
        --dart-output lib/bridge_generated/api.dart \
        -c ios/Runner/bridge_generated.h \
        -c macos/Runner/bridge_generated.h
