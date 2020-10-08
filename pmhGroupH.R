---
  title: "《国际关系定量分析基础》2020秋季"
subtitle: "第一次小组作业(共计100分)"
date: "截止时间：**2020年10月12日 11：59 am**"
author:
  - 潘明花
documentclass: ctexart
output:
  #bookdown::html_document2:
  #bookdown::pdf_document2:
  toc: false
number_sections: no
latex_engine: xelatex
fontsize: 12pt
geometry: margin=1in
editor_options: 
  chunk_output_type: inline
---
  
  ```{r setup, include=FALSE}
library(knitr)
library(formatR)
library(dplyr)
library(ggplot2)
library(scales)
library(ggthemes)

knitr::opts_chunk$set(
  fig.align = "center",
  message = FALSE,
  warning = FALSE,
  tidy = FALSE,
  tidy.opts = list(arrow = TRUE, indent = 2)
)

load(url("https://cc458.github.io/files/terrorism.RData"))
load(url("https://cc458.github.io/files/conflict.RData"))
```


**东南亚地区(如图 \@ref(fig:map))是国际关系和比较政治学界关注的重点地区，本次作业将利用公开数据，对东南亚地区国家的政治、经济、社会、外交等关系进行描述。** 
  
  
  ```{r map, echo=FALSE, fig.height=3, fig.cap="东南亚地图"}
ggplot() + 
  geom_polygon(data = region_map_shp, 
               aes(x = long, y = lat, group = group), size = 0.25) +
  coord_fixed() 
```


**注意事项：**
  
  * 小组作业截止时间：2020年10月12日 11：59 am
* 请直接在R Markdown文件中完成本次作业
* 作业在网络学堂提交，每个小组仅需提交一份
* 提交作业的文件名需以`HW-1-Team-X.Rmd`和`HW-1-Team-X.pdf`(或者`HW-1-Team-X.html`),请将`X`替换为小组编号，如`HW-1-Team-A.Rmd`和`HW-1-Team-A.pdf`。(若R Markdown出现无法`knit`为`pdf`情况，可以使用`bookdown::html_document2:`，则会生成为`html`)
* 请显示每道题的R Code于pdf中，注重Code的整洁性和可读性，可参考[Google's R Style Guide](https://google.github.io/styleguide/Rguide.html)
* 本次作业所需的数据和R Packages已经提供。本次作业需要的数据可以通过以下命令获取(或直接`load("terrorism.RData")`):

```{r data, eval=FALSE}
load(url("https://cc458.github.io/files/terrorism.RData"))
load(url("https://cc458.github.io/files/conflict.RData"))
```

其中，

• terrorism.RData 包括三个数据集: region_map_shp, gtd_region, wdi;
• conflict.RData 包括四个数据集 polity, acled_cnty, ideal_point_wide, ucdp_cnty


# R 基础问题（共15分）

1.(**10分**) 请用 knitr::kable 创建一个 8*3 的表格，总结这 7 个数据框。表格除第一行为 header 外，其余每一行表示一个数据框;除第一列为数据框的名称外，其余两列分别为每一个数据框的变 量 (variables) 和观测量(observations)数。(提示:可以先创建一个包含这些信息的新数据框，然 后再使用 kable 创建表格;也可以利用 R Markdown 手动创建)。
 load(url("https://cc458.github.io/files/terrorism.RData")) load(url("https://cc458.github.io/files/conflict.RData"))

```{r q1, eval=TRUE}

library(knitr)
# 请将代码写在此处;获取数据维度的命令为 dim() dim(wid)

num <- array(dim = c(7,2))
num[1,] <- dim(region_map_shp)
num[2,] <- dim(gtd_region)
num[3,] <- dim(wdi)
num[4,] <- dim(polity)
num[5,] <- dim(acled_cnty)
num[6,] <- dim(ideal_point_wide)
num[7,] <- dim(ucdp_cnty)

# 创建一个数据新的数据集
df <- data.frame(dataset = c("region_map_shp","gtd_region","wdi",
                          "polity","acled_cnty","ideal_point_wide",
                          "ucdp_cnty"),
variable_num = c(num [,1]),
observations_num = c(num[,1])) 

# 利用 kable 产生一个新的表格
kable(df, caption = " 数据集信息")

```

2.(**5分**) `stargazer`是政治学常用的产生统计表格的软件包，请利用 `stargazer`提供一个关于 `wdi`数据的描述性统计表格。

```{r q2, results='asis',eval=TRUE}

# 加载软件包

library(stargazer)
#使用`stargazer`命令产生新的描述性表格
stargazer(wdi, header=FALSE, type='latex', title = "描述性统计结果",
                     digit.separator = "")
```
# 数据可视化问题(共 85 分)

**数据可视化问题(共 85 分)**
3.(*10*) 数据 `region_map_shp` 是一个包含空间信息的数据集，其中变量 `terratck` 包含了东南亚 1991-2006 年之间所遭遇的恐怖主义袭击数量总和。同时数据集 `gtd_region` 记录了东南亚 1991- 2006 年每一次恐怖袭击的经纬度地理位置(变量 `longitude` 和 `latitude`)。请利用 `ggplot2` 这 一软件包产生如下地图 (图 2)，描述各国在此期间的恐怖主义数量分布以及被袭击的地点，并简要 描述你对关于东南亚恐怖袭击活动地理分布的观察。

```{r q3,eval=TRUE,fig.height=3, fig.cap='东南亚恐怖袭击数量分布'}
ggplot() + 
  geom_polygon(data = region_map_shp, 
               aes(x = longtitude, 
                   y = latitude, 
                   group = group,
                   fill = factor(terratck)), 
               size = 0.25) +
  coord_fixed() +
 scale_fill_manual(values = c("#009E73", "#F0E442", "#0072B2","#D55E00", "#CC79A7"),
                    name = "Total number of attacks",
                    na.value = "gray",
                    labels = c("1 - 10","10 - 100","100 - 500","500 - 1000",
                               ">2000", "NA")) +
                               
geom_point(aes(x = gtd_region$longitude, y = gtd_region$latitude, color = "black"),
             alpha=.5, size = 0.5, na.rm= FALSE) + 
  scale_color_manual(name = "",
                     labels = c("Attack locations"),
                     values = "black")  +
  labs(y = "latitude", x = "longitude")

```
4.(**10 分**) 数据集 `wdi` 中的变量 `gdpgrowth` 记录了东南亚各国在 1990-2018 年之间的国民生产总
值增长率。请利用 `ggplot2` 绘制各国在此时间段内的国民生产总值增长率随时间而变化的折线图 (图 3)。并据此图简要谈谈 1997-1998 年亚洲金融危机对东南亚国家经济增长的冲击(提示:可以
使用 `facet_wrap` 分别绘制, 也可以绘制到同一张图)

```{r q4,eval=TRUE,fig.height=5, fig.cap='东南亚各国国民生产总值增长率变化（1990-2018）'}

ggplot(data=wdi,aes(x = year,y = gdpgrowth)) +
  geom_point(colour = "pink", size = 2) +
  geom_line(colour = "black") +
  labs(x = "Year", y = "GDP per capita growth (annual %)",
       caption ="Source: World Bank Group 2020") +
  scale_x_continuous(breaks = seq(1990, 2018, 10)) + 
  facet_wrap(vars(country,
             scales = "free") + 
  theme(strip.text.x = element_text(size = 10, color='white',angle=0),
strip.background = element_rect(fill = "#525252", color='#525252'))
                                       
 ```
 5.(**10 分**) 数据集 `wdi` 中 `gdppc` 表示人均国民生产总值 (GDP per capita，以 2018 年美元为单位)， 变量 `milexp` 表示军费开支占国民生产总值的比值。请利用 `ggplot2` 描述 `gdppc` 与 `milexp` 之间 的关系，并讨论你是否发现什么规律。
 
 ```{r q5,eval=TRUE, fig.height=5, fig.cap='人均GDP与军费开支占GDP比值的关系（东南亚地区）'}
 
 ggplot(data=wdi, aes(x = gdppc,y = milexp)) +
   geom_point() +
   geom_smooth(method = "lm") +
   labs(x = "GDP per capita", 
        y = "Ratio of military expenditure to GDP (%)", 
        caption = "Source: World Bank Group 2020") 
 ```  
 {r q5,eval=TRUE, fig.height=7, fig.cap='人均GDP与军费开支占GDP比值的关系（东南亚各国）'}
 
 ggplot(data=wdi, aes(x = gdppc,y = milexp)) +
   geom_point() +
   geom_smooth(aes(color = factor(country))) +
   labs(x = "GDP per capita", 
        y = "Ratio of military expenditure to GDP (%)", 
        caption = "Source: World Bank Group 2020") +
   facet_wrap(vars(country),
              nrow = 4,
              ncol = 3,
              scales = "free") +
   theme(legend.position = "none")
 ```
 
 6.(**10分**) 数据集`wdi`中`fdi`表示当年外国直接投资（净流入）占国民生产总值的比例。请`ggplot2`及其`facet_wrap`命令，描述东南亚各国在1990-2018年之间外国直接投资的变化情况，并据此简要讨论你观察到何种模式和规律。(提示：参考第4题)
 # 请在此完成代码
 ```{r q6, eval=TRUE, fig.height=7, fig.cap='东南亚各国FDI（净流入）占GDP比例的变化（1990-2018）'}

  ggplot(data=wdi,aes(x = year,y = fdi)) +
   geom_point(colour = "pink", size = 2) +
   geom_line(colour = "black") +
   labs(x = "Year", y = "Foreign Direct Investment Rate (%)",
        caption ="Source: World Bank Group 2020") +
   scale_x_continuous(breaks = seq(1990, 2018, 10)) + 
   facet_wrap(vars(country,
              scales = "free") + 
   theme(strip.text.x = element_text(size = 10, color='white',angle=0),
         strip.background = element_rect(fill = "#525252", color='#525252'))
 ```
 7.(**10分**) 请利用可视化方法，简要描述并讨论数据集`wdi`中`fdi`, `gdppc`, `gdpgrowth`和`milexp`这四个变量的相关关系。
 # 请在此完成代码
 
 ```{r, eval=TRUE, fig.height=4, fig.width=4, fig.cap='数据集wdi中fdi, gdppc, gdpgrowth和milexp四个变量的相关关系图'}
 library(GGally)

 ggcorr(wdi[, c("fdi", "gdppc", "gdpgrowth", "milexp")], 
        palette = "RdBu", label = TRUE, name = "correlation", label_round = 3)
 ```
 
 8.(**10分**) 数据集`polity`是国际关系中最常见的用来测量国家整体类型的数据。其中的变量`polity2`的值域为[-10, +10]，即“最不民主”(-10)到“最民主”(+10)。请利用`ggplot`简要描述这一变量的分布情况。
 
 # 请在此完成代码
 ggplot(data=polity,
        aes(x = (polity2)) +
   geom_() +
   labs( x="Polity2 Index")
 ```
 9.(**10分**) 数据集`acled_cnty`记录了2010-2019年东南亚国家经历的“抗议”（protest）和“骚乱”（riots）数量。利用`ggplot2`绘制各国经历的抗议和骚乱变化情况，并比较抗议和骚乱在各国内部的差异情况。（提示：利用`ggplot`中的`linetype`和`facet_wrap`命令）
 
 ```{r q9, eval=TRUE, fig.height=5,  fig.cap='东南亚各国国内抗议与骚乱数量（2010-2019）'}

 # 此题的部分代码如下
 ggplot(data=acled_cnty, aes(x = year,  y = events, group=event_type)) +
   geom_point() +
   geom_line(aes(linetype=event_type, colors=event_type)  +
   labs(x = "Year", y = "Social unrest",caption="Source: ACLED 2020") +
   scale_x_continuous(breaks = seq(1991, 2019, 5)) +
   scale_y_continuous(breaks = integer_breaks()) + 
   facet_wrap(~country,
              scales = "free") + 
   theme(strip.text.x = element_text(size = 12, color='white',angle=0),
         legend.position = "bottom",
         legend.title = element_blank(),
         strip.background = element_rect(fill = "#525252", color='#525252')) 
 ```
 
 10.(**5分**) 数据集 `ucdp_cnty`记录了东南亚国家1946-2019年之间经历的三种冲突（`type_of_conflict2`:国内冲突、国际冲突以及国际化的国内冲突）的数量(`conflict`)。请利用`ggplot`描述各国分别经历的这三类冲突分布情况。注意其中的缺失值（`NA`），并简要说明为何有缺失值。
 # 此题的部分代码如下
 ```{r q10, eval=TRUE, fig.cap='东南亚各国冲突数量（1946-2019）'}
 ggplot(ucdp_cnty, aes(x = countyname, y = conflict, fill = factor(type_of_conflict2))) + 
   geom_bar(position="dodge", stat="identity") + 
   scale_fill_manual(values=c("yellow", "red", "blue")) + 
   labs(x = "", y = "Count", caption="Source: UCDP 2019") +
   theme_bw() + 
   theme(strip.text.x = element_text(size = 12, color='white',angle=0),
         legend.position = "bottom",
         legend.title = element_blank(),
         strip.background = element_rect(fill = "#525252", color='#525252')) 
 
 11.(**10分**) 数据集`ideal_point_wide`记录了东南亚国家在1973-2018年之间在联合国大会中投票是否同意中国、印度、美国和俄罗斯（苏联）的情况。利用`ggplot`分布绘制东南亚国家在此期间的立场变化。
 
 # 此题的部分代码如下
 ```{r q11, eval=TRUE,fig.height=7,  fig.cap='东南亚各国在联合国大会投票同意中印美俄的情况（1973-2018）'}
 ggplot(ideal_point_wide, aes(x = year, y = agreement), color = type)) +
   geom_line(aes(color = type))  +
   labs(x = "Year", y = "UNGA voting agreement",
        caption ="Source: Bailey, Strezhnev, and Voeten (2017, JCR)") +
   scale_x_continuous(breaks = seq(1973, 2018, 10)) + 
   facet_wrap(~countryname, scales = "free") + 
   theme(strip.text.x = element_text(size = 12, color='white',angle=0),
         legend.position = "bottom",
         legend.title = element_blank(),
         strip.background = element_rect(fill = "#525252", color='#525252')) + 
   scale_colour_manual(values = c("blue","green","gray", "red"))
 ```
 
 
  
  