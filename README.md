# 📚 The Role of Education and Knowledge Elites in Industrialization

## **Overview**
This repository contains two empirical studies investigating the role of **education and knowledge elites** in the **industrialization process**. The studies use historical datasets from **Prussia and France** to examine the factors influencing economic development in the 19th century.

---

## **Study 1: The Role of Education in Industrialization (Prussia)**
### **Objective**
This study explores the impact of **education on industrialization** using a dataset covering **334 Prussian counties** between **1816 and 1849**. The goal is to determine whether **education levels in 1816** influenced **industrial employment shares** by 1849.

### **Data Description**
The dataset includes:
- **1816** – Education levels and pre-industrial development indicators.
- **1849** – Industrial employment shares at the end of the first phase of industrialization.
- Additional variables: **population, factory employment, occupational structure, and school censuses**.

### **Empirical Models**
1. **Ordinary Least Squares (OLS) Regression**
   - Models the relationship between **education levels in 1849** and **industrial employment**.
   - Controls for demographic and geographic factors.

   $$
   Ind_{1849} = \alpha_1 + \beta_1 EdU_{1849} + \gamma_1 X_{1849} + \varepsilon_1
   $$

2. **Instrumental Variables (IV) Regression**
   - Addresses **endogeneity concerns** by using **education levels in 1816** as an instrument for education in 1849.
   - Additional control variables include **pre-industrial economic indicators** (e.g., city size, textile production, technological advances).

   $$
   EdU_{1849} = \alpha_2 + \beta_2 EdU_{1816} + \gamma_2 X_{1849} + \varepsilon_2
   $$

### **Key Findings**
- OLS estimates suggest a **strong positive relationship** between education and industrialization for all sectors, except textile.
- Share of factory workers positively associated with years of schooling, except textile sector
- Older individuals are more likely to be employed in textile factories compared to other industries
- Adding **pre-industrial economic controls** improves the robustness of the results.
- Schooling is beneficial for catch-up growth in sectors that are completely new, but not necessarily in sectors with incremental change
- Developing economies today that aim to develop new industrial sectors can benefit from a strong foundation of schooling
- A curriculum that promotes the ability to learn how to learn may be more effective for catch-up growth in contemporary developing countries compared to a curriculum focused on rote learning.
 


### 🔗 [View the Prussian Education & Industrialization Notebook](https://github.com/OlgaKuzminichna/12.HumanCapitalIndustralisation/blob/main/Education.ipynb)

---

## **Study 2: The Role of Knowledge Elites in Industrialization (France)**
### **Objective**
This study examines whether **the presence of knowledge elites** (measured by **subscription density to the Encyclopédie in the 18th century**) contributed to **city-level economic growth** in **France** during the Industrial Revolution.

### **Data Description**
- **Panel dataset of 193 French cities** covering the **18th and 19th centuries**.
- Key variables:
  - **Subscription density** to the *Encyclopédie* (proxy for knowledge elites).
  - **City population** as a proxy for economic development.
  - **Literacy rates, university access, printing press presence**.
  - **Geographic and cultural characteristics** (e.g., language differences, transport infrastructure).

### **Empirical Model**
- **OLS Regression** examines whether **knowledge elites (S_n)** and **human capital (h_n)** influence economic development.
  
  $$
  y_n = \beta S_n + \gamma h_n + \delta X_n + \varepsilon_n
  $$

  - \( y_n \) = **City population as a proxy for economic development**  
  - \( S_n \) = **Knowledge elites in location \( n \)**  
  - \( h_n \) = **Human capital (literacy, schooling)**  
  - \( X_n \) = **Control variables (geography, institutions, infrastructure)**  
  - \( \varepsilon_n \) = **Error term**  

### **Key Findings**
- The presence of **knowledge elites (subscribers to the Encyclopédie)** is **positively correlated** with city growth.
- **Human capital (literacy rates, university access)** does not seem to have a direct effect, suggesting that **knowledge elites played a unique role** in driving industrialization.
- Cities with **strong pre-industrial knowledge networks** experienced **faster economic expansion**.

### 🔗 [View the French Knowledge Elites & Industrialization Notebook](https://github.com/OlgaKuzminichna/12.HumanCapitalIndustralisation/blob/main/Elites.ipynb)
---

## **Comparison of the Two Studies**
| Feature | **Study 1: Education & Industrialization (Prussia)** | **Study 2: Knowledge Elites & Industrialization (France)** |
|---------|------------------------------------------------|------------------------------------------------|
| **Objective** | Did **education levels** drive industrial employment? | Did **knowledge elites** influence economic development? |
| **Data** | 334 Prussian counties (1816, 1849) | 193 French cities (18th & 19th centuries) |
| **Key Variables** | Education levels, factory employment, demographics | Subscription density, literacy, city growth |
| **Methodology** | OLS & IV regression | OLS regression |
| **Findings** | Education in **1816** strongly predicts industrial employment in **1849** | Knowledge elites (book subscriptions) correlate with **economic growth** |


---

## **How to Use This Repository**
1. **Run the Quarto or Jupyter Notebook files** to replicate the analysis.
2. **Data files** must be placed in the specified directory (`.dta` format).
3. **Install required R packages** before running:
   ```r
   install.packages(c("texreg", "ivreg", "AER", "lmtest", "sandwich", "haven"))
