# Anti-Reflection Coating Design & Bandwidth Analysis
### EECG 252 — Electromagnetic Fields and Waves | Project 1B | Group 6
**Cairo University — Faculty of Engineering — Electronics & Communications Department**
**Instructor:** Dr. Mohamed Alaa · Spring 2026

---

## 📌 Overview

This project designs and analyzes a **quarter-wave anti-reflection coating (ARC)** for a glass substrate (εr = 2.25) at **10 GHz**. The work covers analytical derivation, MATLAB simulation, CST Studio Suite full-wave verification, and a two-layer bandwidth-enhanced design.

| Parameter | Value |
|---|---|
| Substrate | Glass, εr = 2.25 |
| Design frequency | 10 GHz |
| Single-layer coating εr | 1.50 |
| Single-layer thickness | 6.12 mm |

---

## 🎯 Project Tasks Covered

- **Task 7** — Single-layer matching condition derivation (impedance + quarter-wave thickness)
- **Task 8** — |Γ| vs frequency analytical sweep (±50% bandwidth)
- **Task 9** — 20 dB return-loss bandwidth extraction
- **Task 10** — Three-medium stack (air / coating / glass) simulated in CST, overlaid with analytical curve
- **Task 11** — Two-layer binomial coating design for wider bandwidth
- **Extension** — Thickness sensitivity analysis (±10% and beyond, critical error % for RL < 15 dB)
- **Cross-Group Comparison** — Bandwidth comparison with Group 9 (Alumina substrate, εr = 9.8)

---

## 📂 Repository Structure

```
.
├── README.md
├── report/
│   └── Group6_ARC_Report.pdf          # Final written report (max 20 pages)
├── matlab/
│   ├── arc_single_layer.m              # Tasks 8, 9 — |Γ| vs frequency, 20dB BW
│   ├── arc_two_layer.m                 # Task 11 — binomial two-layer design
│   └── arc_sensitivity.m               # Extension — thickness sensitivity sweep
├── cst/
│   ├── single_layer_ARC.cst            # Single-layer CST project file
│   ├── two_layer_ARC.cst               # Two-layer CST project file
│   └── screenshots/                    # Annotated CST screenshots (Group 6 label)
├── figures/
│   ├── single_layer_diagram.tex        # TikZ structure diagram
│   └── two_layer_diagram.tex           # TikZ structure diagram
└── presentation/
    └── Group6_ARC_Presentation.pptx    # 5-slide summary presentation
```

---

## 🔬 Key Results

### Single-Layer Design (Task 7–10)

| Quantity | Value |
|---|---|
| η_air | 377 Ω |
| η_glass | 251.3 Ω |
| Required coating impedance | 307.8 Ω |
| Coating εr | 1.50 |
| Coating thickness | 6.12 mm |
| S11 at 10 GHz (CST) | ≈ −72 dB |
| 20 dB return-loss bandwidth | 6.56 GHz (6.72 – 13.28 GHz) |

### Two-Layer Binomial Design (Task 11)

| Layer | εr | Impedance | Thickness |
|---|---|---|---|
| Layer 1 (air side) | 1.225 | 340.7 Ω | 6.78 mm |
| Layer 2 (glass side) | 1.800 | 281.0 Ω | 5.59 mm |

**Bandwidth improvement:** 6.56 GHz → ~9.85 GHz (+50%)

### Extension — Thickness Sensitivity

| Thickness error | Return loss at 10 GHz |
|---|---|
| 0% | 74.2 dB |
| ±10% | ~30 dB |
| ±69% | ~15 dB (failure threshold) |

### Cross-Group Comparison (vs Group 9 — Alumina, εr = 9.8)

| Parameter | Group 6 (Glass) | Group 9 (Alumina) |
|---|---|---|
| Impedance ratio η₀/ηs | 1.50 | 3.13 |
| 20 dB Bandwidth | 6.4 GHz | 2.2 GHz |

A higher substrate εr produces a larger impedance mismatch, which makes the quarter-wave transformer more frequency-sensitive — hence Group 9's narrower bandwidth.

---

## 🛠️ How to Reproduce

### MATLAB
1. Open `matlab/arc_single_layer.m` in MATLAB.
2. Run the script — it prints impedance values, the 20 dB bandwidth, and plots |Γ| / Return Loss vs frequency.
3. Run `arc_two_layer.m` for the two-layer comparison.
4. Run `arc_sensitivity.m` for the thickness sensitivity analysis.

### CST Studio Suite
1. Open `cst/single_layer_ARC.cst` (CST Studio Suite 2025 recommended).
2. Structure: Air background / ARC coating brick (εr=1.5, 6.12 mm) / Glass brick (εr=2.25).
3. Boundary conditions: Electric (X), Magnetic (Y), Open (Z) — enforces the infinite plane-wave condition.
4. Run the Time Domain solver over 5–15 GHz and inspect **Results → S-Parameters → S1,1**.
5. Repeat with `two_layer_ARC.cst` for the binomial design.

---

## 👥 Group Members & Contributions

| Member | Contribution |
|---|---|
| Anas Mohamed | Analytical derivation (Task 7) |
| Radwa Ahmed | |Γ| vs frequency analysis & bandwidth (Tasks 8–9) |
| Amin Mohamed | CST single-layer simulation & overlay (Task 10) |
| Ahmed Hassan | Two-layer design & CST verification (Task 11) |
| Ahmed Amir | Extension analysis, cross-group comparison, report assembly |

*(Edit names/roles to match your actual contribution statement.)*

---

## 📜 Academic Integrity Note

All analytical derivations, MATLAB scripts, and CST simulations in this repository were independently developed by Group 6 for the assigned parameters (Glass substrate, εr = 2.25, 10 GHz), in accordance with the EECG 252 Academic Integrity and AI Use Policy.
