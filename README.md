# Sectoral and Demographic Analysis of Irish Earnings (2011-2023)
### By: Debangshu Baidya
#### Tool Used: R Studio, R Programming Language
---
## Project Background
This study investigates the temporal evolution of weekly and annual earnings in Ireland between 2011 and 2023, leveraging the publically available dataset form https://data.cso.ie/ **(Central Statistics Office)**. The **primary research objective** is to determine the extent to which **earnings** trends differ across **industrial sectors**, **demographic age groups**, and **geographical regions**, and to identify the principal determinants of these trends. The methodological approach includes **data visualization**, the application of **statistical modeling techniques**, and **geographical information system (GIS) mapping**.

## Summary
This project comprehensively analyzed Irish earnings data from 2011 to 2023, revealing upward trends, particularly post-2015, with significant variations across sectors, age groups, and regions. Employing descriptive statistics, interactive visualizations, statistical modeling (GLM/GAM), and geographical mapping, the analysis highlighted that earnings generally increase with age, exhibit greater dispersion among older workers, and show stronger growth in higher percentiles, with weekly earnings being a strong predictor of annual income and notable geographical disparities existing across counties. Ultimately, this study provides valuable insights into the dynamics and evolution of the Irish earnings landscape over a decade.

## Entity Relationship Diagram
<img width="496" alt="ERD" src="https://github.com/user-attachments/assets/34fcbdf3-13c9-421b-b9c4-ed686e49a698" />

## Analysis
### Weekly and Yearly Earning Distribution by Age Group

<img width="784" alt="Weekly Distrbution" src="https://github.com/user-attachments/assets/78ce1fdb-d99b-45a3-aa63-b0dc50f1866a" />

This boxplot visualizes the distribution of weekly earnings across different age groups, revealing several key insights. Younger workers (15-24 years) exhibit the lowest median earnings, with relatively tight interquartile ranges (IQR), indicating less variation in earnings. As age increases, earnings generally rise, with the 40-49 and 50-59 age groups showing the highest median weekly earnings. However, earnings dispersion also increases with age, as evidenced by the wider IQRs and more frequent outliers in older groups, suggesting greater wage inequality among more experienced workers. The presence of many outliers, especially in older age groups, indicates that some individuals earn significantly above the typical range, likely due to senior positions, high-skilled professions, or bonuses. Interestingly, the 60+ age group sees a decline in median earnings compared to the peak earning years, potentially due to retirement transitions or part-time employment. This distribution highlights the expected career wage trajectory, where earnings grow with experience before tapering off later in life.


This boxplot of annual earnings across age groups highlights the expected income trajectory over a working lifetime. The median earnings increase steadily from younger age groups, peaking around the 40-49 and 50-59 age groups before slightly declining in the 60+ category. The widening interquartile range (IQR) as age increases suggests that income disparity grows with experience, likely due to differences in career progression, job roles, and seniority levels. Notably, the presence of numerous high-earning outliers, especially in the older age groups, reflects the impact of bonuses, executive positions, and specialized skills commanding higher salaries. The decline in median earnings for the 60+ group may be attributed to retirement transitions, reduced working hours, or a shift toward lower-paying roles post-retirement. Overall, the distribution underscores the economic benefits of experience and tenure while also showcasing increasing wage inequality among older professionals.

### Earnings Trend Over Time

<img width="783" alt="Yearly Distribution" src="https://github.com/user-attachments/assets/95c716db-625e-45f6-ac8f-40377952aa50" />

The earnings trend in Ireland over the years exhibits a significant upward trajectory, particularly from 2015 onward, which aligns with the country’s post-recession economic recovery. Between 2011 and 2014, wages remained relatively stagnant, reflecting the lingering effects of the global financial crisis and Ireland’s subsequent austerity measures under the EU-IMF bailout program. However, from 2015 onward, the sharp rise in earnings coincides with Ireland’s economic boom, fueled by a surge in foreign direct investment (FDI), particularly in the tech and pharmaceutical sectors. The steep increase post-2019 could be linked to labor market tightening, minimum wage increases, and inflationary pressures, further exacerbated by the COVID-19 pandemic, which led to wage subsidies and support schemes that influenced overall earnings. Additionally, the rapid rise in salaries after 2020 reflects Ireland’s strong post-pandemic recovery, driven by multinational corporations and a resilient domestic economy. This trend underscores Ireland’s shift toward a high-income economy, albeit with concerns over cost-of-living increases and wage disparity across different sectors.

### Annual Earnings Percentile Distribution

<img width="792" alt="heatmap" src="https://github.com/user-attachments/assets/9c0368af-2459-424b-9f7d-4132bdff68f7" />

The heatmap illustrates the distribution of annual earnings percentiles over time, showing a clear upward trend, especially in the higher percentiles (e.g., the 95th and 90th percentiles). This suggests that high earners in Ireland have seen significant wage growth, while lower percentiles have experienced relatively stagnant wage progression. This aligns with Ireland’s evolving labor market dynamics, where high-skilled and tech-sector jobs have surged, benefiting top earners. Meanwhile, wage growth for lower-income workers has been slower, possibly due to factors such as automation, labor outsourcing, and a rise in gig economy employment. The widening gap also reflects broader global trends of wage polarization, where knowledge-intensive industries offer higher rewards while traditional sectors struggle with wage stagnation.

### Generalised Additive Model (Regression)

<img width="625" alt="GAM" src="https://github.com/user-attachments/assets/352f073c-8f99-4fd6-9f77-b7e024567f9e" />

The Generalized Additive Model (GAM) plot illustrates the smooth relationship between weekly earnings (Euros_Weekly) and its modeled effect. The curve suggests a nonlinear but generally increasing relationship, with a steeper slope at higher income levels, indicating accelerating gains for higher earners. The confidence bands (dashed lines) remain relatively narrow, suggesting strong model confidence across most of the range. However, at the lower end, the confidence bands widen slightly, possibly due to greater variance in earnings for lower-wage workers. This pattern aligns with Ireland’s labor market trends, where wage growth disproportionately benefits higher-income brackets, particularly in tech and finance, while lower-income workers see more modest increases, reflecting potential wage polarization.

### Geographical Analysis

<img width="775" alt="Ireland" src="https://github.com/user-attachments/assets/c8a5e865-5f73-430a-b1f2-d87f96b79286" />

Between 2011 and 2021, Ireland saw a significant increase in total industrial earnings across its counties, as depicted in the two maps. In 2011 (left image), earnings were relatively lower, with most counties displaying lighter shades of green, signifying lower total earnings. By 2021 (right image), the colors have transitioned to darker shades of blue, indicating a marked rise in earnings across all regions.

This growth in industrial earnings correlates strongly with Ireland’s economic and industrial developments over the decade. Key events that influenced this trend include:

***Economic Recovery Post-2008 Crisis***

In 2011, Ireland was still recovering from the financial crisis, and industrial growth was sluggish. Government austerity measures were in place, and investment in key industries was still regaining momentum. This is reflected in the lower earnings in the 2011 map.

***Growth of the Technology and Pharmaceutical Sectors***

From 2011 to 2021, Ireland became a hub for multinational corporations, particularly in technology and pharmaceuticals. Companies like Apple, Google, Facebook, and Pfizer significantly expanded their operations. This influx of investment contributed to rising wages and industrial earnings, particularly in counties with strong industrial and tech presence.

***Brexit (2016-2020) and Its Impact***

The uncertainty and eventual execution of Brexit led to changes in trade dynamics, with some industries in Ireland benefiting from companies relocating operations from the UK. Certain counties with strong manufacturing and logistics sectors likely saw increased earnings due to these shifts.

***COVID-19 and Industrial Resilience (2020-2021)***

The pandemic had mixed effects on industries, but Ireland’s pharmaceutical and tech industries remained robust, even experiencing growth due to increased global demand. The rise in earnings in 2021 suggests that certain industrial sectors thrived despite economic challenges.

## Conclusion

Looking back at the decade between 2011 and 2023 in Ireland, my analysis revealed a picture of rising fortunes for many, especially after the economic clouds of the early years began to lift around 2015. This suggested more money in people's pockets, both weekly and annually. However, the story isn't the same for everyone. I found that what people earned could really depend on the industry they were in, how old they were, and even where in Ireland they lived. Generally, those in their prime working years tended to earn the most, but it was interesting to see that the gap between the highest and lowest earners seemed to have grown over time. Even though most counties showed an overall increase in earnings, highlighting the country's progress, these findings remind me that the economic journey hasn't been uniform for all. Ultimately, understanding these trends helps me gain a clearer sense of how the Irish economy has evolved and its implications for people across the nation.



