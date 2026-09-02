"""
Day3_script_demo.py

This is a Python SCRIPT, not a Jupyter Notebook.

In a notebook, you run one cell at a time and see each result as you go.
Here, the whole file runs top to bottom in one go, and everything is
printed to the terminal at once.

How to run it:
    1. Open Anaconda Prompt (Windows) or Terminal (Mac)
    2. cd to the folder containing this file
    3. Type:  python Day3_script_demo.py

Uses only Python's built-in tools -- no libraries needed.
"""

# --- Data: seats won by the leading party at each Dail general election ---
# (Same dataset we used in the notebook)
years = [1992, 1997, 2002, 2007, 2011, 2016, 2020]
parties = [
    "Fianna Fail", "Fianna Fail", "Fianna Fail", "Fianna Fail",
    "Fine Gael", "Fine Gael", "Fianna Fail",
]
seats = [68, 77, 81, 78, 76, 50, 38]

print("=" * 45)
print("Dail Election Results: Leading Party Seats")
print("=" * 45)

# --- Print one line per election ---
for year, party, n_seats in zip(years, parties, seats):
    print(f"{year}: {party} won {n_seats} seats")

# --- Basic stats ---
total_elections = len(years)
average_seats = sum(seats) / total_elections
best_seats = max(seats)
worst_seats = min(seats)
best_year = years[seats.index(best_seats)]
worst_year = years[seats.index(worst_seats)]

print("-" * 45)
print(f"Elections analysed : {total_elections}")
print(f"Average seats won  : {average_seats:.1f}")
print(f"Best result        : {best_seats} seats in {best_year}")
print(f"Worst result       : {worst_seats} seats in {worst_year}")
print("-" * 45)

print("\nScript finished running -- no notebook, no cells, just one file!")
