import uuid
import sys

def main(argv):
    filepath = argv[1]
    lines = []
    with open(filepath) as infile:
        for line in infile:
            gen = str(uuid.uuid4())
            line = line.replace('id: ""', 'id: "' + gen + '"')
            lines.append(line)
    with open(filepath, 'w') as outfile:
        for line in lines:
            outfile.write(line)

if __name__ == "__main__":
    main(sys.argv)
