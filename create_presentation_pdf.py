import os
import re
import urllib.request
from PIL import Image

def main():
    with open('README.md', 'r', encoding='utf-8') as f:
        content = f.read()

    section_match = re.search(r'## Contest Presentation.*?(?=---|\Z)', content, re.DOTALL)
    if not section_match:
        print("Error: Could not find '## Contest Presentation' section in README.md")
        return

    section = section_match.group(0)
    pattern = r'alt=\"(slide-\d+)\"\s+src=\"(https://github\.com/user-attachments/assets/[^\"]+)\"'
    matches = re.findall(pattern, section)
    
    print(f"Found {len(matches)} slides in README.md")
    
    os.makedirs('slides_cache', exist_ok=True)
    images = []
    
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36'
    }

    for idx, (slide_name, url) in enumerate(matches, 1):
        filename = f"slides_cache/{slide_name}.png"
        print(f"[{idx}/{len(matches)}] Downloading {slide_name} from {url}...")
        
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req) as resp:
            data = resp.read()
            with open(filename, 'wb') as out_f:
                out_f.write(data)
                
        img = Image.open(filename)
        if img.mode != 'RGB':
            img = img.convert('RGB')
        images.append(img)
        print(f"  Downloaded: {slide_name} (Size: {img.size[0]}x{img.size[1]})")

    if not images:
        print("No images downloaded.")
        return

    pdf_path_1 = "EcoSprint_Contest_Presentation.pdf"
    pdf_path_2 = "ClimaCore_Contest_Presentation.pdf"

    print(f"\nCompiling {len(images)} slides into PDF: {pdf_path_1}...")
    images[0].save(
        pdf_path_1,
        save_all=True,
        append_images=images[1:],
        quality=95,
        resolution=150.0
    )
    print(f"Saved: {pdf_path_1} ({os.path.getsize(pdf_path_1) / (1024*1024):.2f} MB)")

    images[0].save(
        pdf_path_2,
        save_all=True,
        append_images=images[1:],
        quality=95,
        resolution=150.0
    )
    print(f"Saved: {pdf_path_2} ({os.path.getsize(pdf_path_2) / (1024*1024):.2f} MB)")
    print("\nPresentation PDF successfully created!")

if __name__ == '__main__':
    main()
