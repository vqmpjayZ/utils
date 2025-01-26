def process_image(url):
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()

        image = Image.open(BytesIO(response.content))

        image = image.convert("RGB")

        image = image.resize((32, 32), Image.ANTIALIAS)

        pixel_data = []
        for y in range(32):
            row = []
            for x in range(32):
                r, g, b = image.getpixel((x, y))
                row.append({"r": r, "g": g, "b": b})
            pixel_data.append(row)

        return {"pixels": pixel_data}

    except requests.exceptions.RequestException as e:
        return {"error": f"Failed to fetch image: {e}"}
    except Exception as e:
        return {"error": f"An error occurred: {e}"}
