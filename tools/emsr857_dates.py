"""Print the acquisition dates stored inside Copernicus EMS product zips (EMSR857_AOI01_DEL_MONIT01_v1.zip, ...).
Usage:  python emsr857_dates.py "C:\\path\\to\\folder\\with\\the\\zips"      (standard library only)
It looks in the imageryFootprint / metadata files of every zip and prints every date it finds, per product."""
import re, sys, zipfile
from pathlib import Path

ISO = re.compile(r"20(?:25|26|27)-\d{2}-\d{2}")
DMY = re.compile(r"\b(\d{2})/(\d{2})/(20(?:25|26|27))\b")
WANT = re.compile(r"imagery.?footprint|metadata|acquisition|source", re.I)
EXT = (".json", ".geojson", ".xml", ".txt", ".dbf", ".csv")


def dates_in(text):
    found = set(ISO.findall(text))
    found |= {f"{y}-{m}-{d}" for d, m, y in DMY.findall(text)}
    return sorted(found)


def main(folder):
    zips = sorted(Path(folder).glob("*.zip"))
    if not zips:
        print("no .zip files in", folder)
        return
    for z in zips:
        try:
            zf = zipfile.ZipFile(z)
        except Exception as e:
            print(f"{z.name}: cannot open ({e})")
            continue
        hits, seen = {}, []
        for n in zf.namelist():
            if n.lower().endswith(EXT) and WANT.search(Path(n).name):
                seen.append(Path(n).name)
                d = dates_in(zf.read(n).decode("latin-1", "ignore"))
                if d:
                    hits[Path(n).name] = d
        label = z.stem
        if hits:
            alld = sorted({d for v in hits.values() for d in v})
            print(f"{label}: {', '.join(alld[:6])}   (from {', '.join(list(hits)[:2])})")
        else:
            print(f"{label}: no date found; files checked: {', '.join(seen[:4]) or 'none matched'}")


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else ".")
