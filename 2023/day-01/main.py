
my_dict = {
    1: ("1", "one"),
    2: ("2", "two"),
    3: ("3", "three"),
    4: ("4", "four"),
    5: ("5", "five"),
    6: ("6", "six"),
    7: ("7", "seven"),
    8: ("8", "eight"),
    9: ("9", "nine")
}

def find_keyword(d: dict[int, tuple[str, ...]], text: str, reverse: bool = False) -> int | None:
    """
    Find the first key in the dictionary to match one of its values from either end of the text
    """
    check_func = text.endswith if reverse else text.startswith
    for key, keywords in d.items():
        if check_func(keywords):
            return key
    return None

def find(line: str, reverse: bool = False) -> int | None:
    """
    Find the first matching keyword from either end of the line
    """
    while line:
        key = find_keyword(my_dict, line, reverse)
        if key is not None:
            return key
        line = line[:-1] if reverse else line[1:]
    return None

def main():
    with open("day-01/input.txt", "r") as f:
        total = 0
        for line in f:
            line = line.strip()
            first = find(line, False)
            last = find(line, True)
            total += int(first)*10 + int(last)
        print("Answer: ", total)

if __name__ == "__main__":
    main()



