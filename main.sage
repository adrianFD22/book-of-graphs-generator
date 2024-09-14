
# A Sage script for searching graphs satisfying a given property
# and display them in a pdf using pdflatex.


# ----------------
#    Parameters
# ----------------

from_vertices = 1
to_vertices = 9

def property(G):
    # A property to check for G, for example, being regular. Must return a boolean value
    return G.is_regular()

title = "Title"
preamble_text = "This text is shown before all the graphs."
n_cols = 5


# ----------------
#    Functions
# ----------------

import os
from sage.graphs.graph_plot import GraphPlot

options = {
    # Vertices
    'vertex_color': 'black',
    'vertex_size': 200,
    'vertex_labels': False,
    'vertex_labels': False,

    # Edges
    'edge_color': 'black',
    'edge_colors': None,
    'edge_labels': False,
    'edge_style': 'solid',

    # Layout
    'layout': None,
    'spring': False,
    'iterations': 500,
    'heights': None,
    'graph_border': False,

    # Other
    #'tree_orientation': 'down',
    #'talk': False,
    #'color_by_label': False,
    #'partition': None,
    #'dist': .075,
    #'max_dist': 1.5,
    #'loop_size': .075,
    #'edge_labels_background': 'transparent'
}

def graph_2png(G, name, opts):
    G_plot = GraphPlot(G, opts).plot()
    path = name
    G_plot.save(path)


# ----------------
#      Main
# ----------------

#### Computations ####
# Clean
os.system("rm -f Images/*.png")

# Find all graphs for which property holds
images_list = []

print("Exploring graphs")
for n in range(from_vertices, to_vertices+1):
    print("  Exploring n =", n, "...")

    for G in graphs.nauty_geng(str(n) + " -c"):     # Check every graph with n vertices

        # If property holds, save the graph
        if property(G):
            curr_index = len(images_list) + 1
            name = "Images/" + str(curr_index) + "_graph.png"
            images_list.append(name)

            graph_2png(G, name, options)


#### Tex file ####
print("Compiling tex...")

tex_str = "\n"
tex_str += r"\documentclass{article}" + "\n"
tex_str += r"\usepackage{geometry}" + "\n"
tex_str += r"\geometry{" + "\n"
tex_str += r"left=30," + "\n"
tex_str += r"right=30," + "\n"
tex_str += r"top=30," + "\n"
tex_str += r"bottom=50" + "\n"
tex_str += r"}" + "\n"
tex_str += r"\pagestyle{plain}" + "\n"
tex_str += r"" + "\n"
tex_str += r"\usepackage{tikz}" + "\n"
tex_str += r"\usepackage[dvipsnames]{xcolor}" + "\n"
tex_str += r"\usepackage{multicol}" + "\n"
tex_str += r"\usepackage{wrapfig}" + "\n"
tex_str += r"\usepackage[labelformat=empty]{caption}" + "\n"
tex_str += r"\usepackage{hyperref}" + "\n"
tex_str += "\n"
tex_str += r"\title{" + title + "}" + "\n"
tex_str += r"\date{}" + "\n"
tex_str += r"" + "\n"
tex_str += r"" + "\n"
tex_str += r"\begin{document}" + "\n"
tex_str += r"\maketitle" + "\n"
tex_str += r"\vspace{-30}" + "\n"
tex_str += r"{" + "\n"
tex_str += preamble_text + "\n"
tex_str += r"}" + "\n"
tex_str += r"\vspace{20}" + "\n"

# Add all images
tex_str += r"\begin{document}" + "\n"
tex_str += r"\begin{multicols}{" + str(n_cols) + "}" + "\n"

for curr_image in images_list:
    curr_number = curr_image.split("/")[-1].split("_")[0]

    tex_str += r"\begin{wrapfigure}{c}{0.7\linewidth}" + "\n"
    tex_str += r"\centering" + "\n"
    tex_str += r"\includegraphics[width=\linewidth]{" + curr_image + "}" + "\n"
    tex_str += r"\caption{$G_{" + curr_number + r"}$}" + "\n"
    tex_str += r"\end{wrapfigure}" + "\n"
    tex_str += "\n"

tex_str += r"\end{multicols}" + "\n"
tex_str += r"\end{document}" + "\n"

# Write to file
with open("tex/main.tex", 'w') as file:
    file.write(tex_str)

# Compile tex
os.system("pdflatex -interaction=nonstopmode -output-directory=tex tex/main.tex &> /dev/null")    # Compile file
os.system("cp tex/main.pdf book_of_graphs.pdf")                       # Place pdf in current directory

print("Done")
