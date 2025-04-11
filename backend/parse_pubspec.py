import yaml
import os

def get_asset_paths_from_pubspec(pubspec_path):
    if not os.path.exists(pubspec_path):
        raise FileNotFoundError(f"ไม่พบไฟล์: {pubspec_path}")

    with open(pubspec_path, 'r', encoding='utf-8') as file:
        data = yaml.safe_load(file)

    asset_paths = []
    flutter_section = data.get('flutter', {})
    assets = flutter_section.get('assets', [])
    
    for asset in assets:
        if isinstance(asset, str):
            asset_paths.append(asset)

    return asset_paths


if __name__ == '__main__':
    pubspec_file = os.path.join("..", "flutter", "pubspec.yaml")  # ปรับ path ให้ถูกกับโฟลเดอร์จริงของคุณ
    assets = get_asset_paths_from_pubspec(pubspec_file)

    print("📁 Assets Paths จาก pubspec.yaml:")
    for path in assets:
        print(f"- {path}")
