import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.cluster import DBSCAN

def eigenvalues_A(s, t):
    A = np.array([
        [-1,  2,  0,  1,  1,  t],
        [-1,  0,  1,  s,  2, -1],
        [ 1,  0, -2, -1, -1, -1],
        [-2,  2,  2,  0,  2,  1],
        [ 0,  0, -2,  0,  2,  2],
        [ 1, -1,  2, -2, -2, -1]
    ], dtype=float)
    return np.linalg.eigvals(A)

def eigen_table_only_reim(s_values, t_values):
    n = len(s_values) * len(t_values) * 6
    Re = np.empty(n, dtype=float)
    Im = np.empty(n, dtype=float)

    k = 0
    for s in s_values:
        for t in t_values:
            eigs = eigenvalues_A(s, t)
            Re[k:k+6] = eigs.real
            Im[k:k+6] = eigs.imag
            k += 6

    return pd.DataFrame({"Re": Re, "Im": Im})


s_vals = np.linspace(-100, 100, 200)
t_vals = np.linspace(-100, 100, 200)


df = eigen_table_only_reim(s_vals, t_vals)

X = df[["Re", "Im"]].values

db = DBSCAN(
    eps=0.15,        
    min_samples=35   
)

labels = db.fit_predict(X)
df["cluster"] = labels

print(df["cluster"].value_counts())

theta = np.pi / 4  # 45 grados CCW

R = np.array([
    [np.cos(theta), -np.sin(theta)],
    [np.sin(theta),  np.cos(theta)]
])

XY = df[["Re", "Im"]].values
XY_rot = XY @ R.T

df["Re"] = XY_rot[:, 0]
df["Im"] = XY_rot[:, 1]


print(f"total de clusters sin contar ruido: {len(df['cluster'].unique())-1}")


cluster_colors = {
    -1: "green",
     0: "darkgreen",
     1: "darkgreen",
     2: "darkgreen",
     3: "darkgreen",
     4: "darkgreen",
     5: "darkgreen",
     6: "darkgreen",
     7: "darkgreen"
}

plt.figure(figsize=(7,7))

for c in sorted(df["cluster"].unique()):
    sub = df[df["cluster"] == c]
    plt.scatter(
        sub["Re"],
        sub["Im"],
        s=0.5 if c != -1 else 0.3,
        color=cluster_colors.get(c, "gray"),
        alpha=0.07 if c != -1 else 0.3
    )

plt.gca().set_aspect("equal")
plt.axis("off")
plt.show()
