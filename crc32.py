#!/usr/bin/env python3

import sys

def make_crc32_table(poly=0xEDB88320):
    table = []
    for i in range(256):
        crc = i
        for _ in range(8):
            if crc & 1:
                crc = (crc >> 1) ^ poly
            else:
                crc >>= 1
        table.append(crc)
    return table

def crc32(data: bytes, table=None) -> int:
    if table is None:
        table = make_crc32_table()

    crc = 0xFFFFFFFF
    for byte in data:
        crc = (crc >> 8) ^ table[(crc ^ byte) & 0xFF]
    return crc ^ 0xFFFFFFFF

def main():
    if len(sys.argv) != 2:
        print(f"Użycie: {sys.argv[0]} <plik>")
        sys.exit(1)

    filepath = sys.argv[1]

    try:
        with open(filepath, "rb") as f:
            data = f.read()
    except Exception as e:
        print(f"Błąd otwierania pliku: {e}")
        sys.exit(1)

    result = crc32(data)
    print(f"{result:08x}")

if __name__ == "__main__":
    main()
