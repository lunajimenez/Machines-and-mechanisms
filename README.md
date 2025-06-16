# ⚙️ Machines and Mechanisms – Análisis de Mecanismos en Scilab

Este repositorio contiene ejercicios y desarrollos del curso de **Mecanismos**, centrados en el **análisis cinemático y cinético de sistemas planos en 2D**, principalmente mediante **Scilab**. Incluye el diseño y estudio de **levas**, así como mecanismos con eslabones deslizantes y animaciones programadas.

---

## 📚 Contenido

* 🕠 **Diseño de levas (Cam Design)**
  Con distintos perfiles de movimiento:

  * Polinomial (3-4-5, 4-5-6-7)
  * Cicloidal
  * Senoidal y modificada
  * Trapezoidal modificada
  * Critical Path Motion (CPM)

* ⚙️ **Análisis cinemático**

  * Posiciones, velocidades, aceleraciones
  * Sacudimientos (jerk)

* 🧮 **Análisis cinético**

  * Fuerzas, momentos y reacciones en juntas
  * Cálculo del torque necesario

* 🪪 **Evaluaciones y pruebas**

  * Talleres, quizzes y simulaciones interactivas

* 🎞️ **Animaciones 2D** de mecanismos

  * Simulación de eslabones y movimiento en plano usando el archivo animador `Q2v3.sce` y funciones gráficas de Scilab

---

## 📁 Estructura de archivos (ejemplos destacados)

| Archivo                                 | Descripción                                                    |
| --------------------------------------- | -------------------------------------------------------------- |
| `CamDesignSeguidores.sci`               | Diseño de leva con seguidores tipo SVAJ                        |
| `DiseñoMecanismoProyecto.sci`           | Proyecto final de curso de diseño de mecanismo completo        |
| `ClaseAnalisisCinetico.sci`             | Cálculo de fuerzas, aceleraciones y sacudimientos              |
| `EjslabonDeslizante.sci`                | Análisis de mecanismo con eslabón deslizante                   |
| `EjercicioEnClaseMecanismos2.sci`       | Ejercicio integral de análisis cinemático y dinámico           |
| `Pto3PolinomialesGraficasCompletas.sci` | Comparación entre diferentes funciones polinomiales para levas |
| `Q2v3.sce`                              | Animador de mecanismo en 2D (código base del profesor)         |
| `quiz_mecanismos.ipynb`                 | Resolución de quiz usando Python como apoyo (corte 2)          |

---

## ▶️ Cómo usar

1. Abre **Scilab** (versión recomendada: 6.1.x).

2. Ejecuta el archivo que desees analizar:

   ```scilab
   exec("EjercicioEnClaseMecanismos2.sci");
   ```

3. Los scripts generan:

   * Cálculos numéricos
   * Gráficos de resultados (posición, velocidad, aceleración, fuerzas)
   * En algunos casos, animaciones 2D del mecanismo

---

## 📌 Notas adicionales

* Los archivos están comentados en **español**.
* Algunos `.sci` se centran en funciones reutilizables; otros son scripts completos (`.sce`).
* Las animaciones y gráficas se generan con funciones básicas de Scilab 
---

## 💡 Requisitos

* [Scilab](https://www.scilab.org/)
* Sistema operativo compatible
* Se recomienda usar la interfaz gráfica de Scilab para visualizar las animaciones

---

## 📩 Contacto

Autora: **Luna Katalina Quintero Jiménez**
---

## 👨‍🏫 Créditos académicos

Todos los códigos de este repositorio fueron realizados a lo largo del curso **"Mecanismos"**, dictado por el profesor **José Alberto Martínez Trespalacios** en la **Universidad Tecnológica de Bolívar**.

El profesor nos enseñó a diseñar mecanismos con Scilab y la mayoría de los archivos presentes están inspirados en su metodología, estilo de programación y ejercicios propuestos durante el curso.

El animador `Q2v3.sce` fue completamente elaborado por él. Todos los créditos de este código, así como del material conceptual base, se reservan a su autoría y a la **Universidad Tecnológica de Bolívar**.

---

## ⭐ Si te resultó útil, ¡no olvides dejar una estrellita :D!

