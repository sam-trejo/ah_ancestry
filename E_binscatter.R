# admixture
library(dplyr)
library(ggplot2)
library(haven)
source("http://pcwww.liv.ac.uk/~william/R/crosstab.r")
library(binsreg)
library(patchwork)

setwd("/Users/uchikoshi/Dropbox (Princeton)/~~GeneticAncestry/~ancestry_identity")
link <- read_xpt("Data/GID_link.xpt") %>% 
  mutate(AID=as.numeric(AID))

ssgac <- read_xpt("Data/ssgacpgi.xpt") %>% 
  dplyr::select(1) %>% 
  mutate(ssgac="Yes") %>% 
  mutate(AID=as.numeric(AID))

dta <- read_dta("Data/admixture_race.dta") %>% 
  dplyr::select(AID=aid,everything()) %>% 
  mutate(ses = ntile(sespc_al, 2)) %>% 
  mutate(
    ses = case_when(
      ses == 1 ~ "Low SES",
      ses == 2 ~ "High SES"),
    noneng = case_when(
      noneng == 0 ~ "Only English use",
      noneng == 1 ~ "Non-English use"),
    female = case_when(
      female == 0 ~ "Male",
      female == 1 ~ "Female"),
    gene1 = case_when(
      gene1 == 0 ~ "1st/2nd generation",
      gene1 == 1 ~ "3rd+ generation"))

pop <- read_dta("Data/ancestry.dta") 

race <- dta %>% 
  left_join(link,by = "AID") %>% 
  dplyr::select(gid=GID,aid=AID,everything()) %>% 
  filter(is.na(gid)==F) %>% 
  pivot_longer(c(9:12), names_to = "ancestry", values_to = "value") %>% 
  mutate(ancestry = case_when(
    ancestry == "afr" ~ "African",
    ancestry == "amr" ~ "American",
    ancestry == "eur" ~ "European",
    ancestry == "asa" ~ "Asian"
  ))

a <- binsreg(race$race_w3_wh, race$value, by=race$ancestry, 
             polyreg=6, nbins=50, legendoff = T, ci = T, cigridmean=T) 
b <- binsreg(race$race_w3_bl, race$value, by=race$ancestry, 
             polyreg=6, nbins=50, legendTitle = "Ancestry groups") 
c <- binsreg(race$race_w3_hs, race$value, by=race$ancestry, 
             polyreg=6, nbins=50, legendoff = T) 
d <- binsreg(race$race_w3_as, race$value, by=race$ancestry, 
             polyreg=6, nbins=50, legendoff = T) 

fig1 <- a$bins_plot +
  ylab("Racial identity: white") +xlab("")+theme_few()+
  theme(legend.title=element_blank())
fig2 <- b$bins_plot +
  ylab("Racial identity: black") +xlab("")+theme_few()+
  theme(legend.position=c(.8, .6))
fig3 <- c$bins_plot +
  ylab("Racial identity: hispanic") +xlab("% genetic ancestry")+theme_few()
fig4 <- d$bins_plot +
  ylab("Racial identity: asian") +xlab("% genetic ancestry")+theme_few()

fig <- (fig1 + fig2) / (fig3+fig4) + plot_layout(guides = "collect")
ggsave(fig,height=6,width=9,dpi=200, filename="binnedplot.pdf",  family = "Helvetica")

# lapply(c("gene1", "noneng", "female", "ses"),function(i){
#   racex <- race %>% 
#     filter(ancestry=="African")
# })

######################################################################
# Heterogenetity among blacks
######################################################################
racex <- race %>% 
  filter(ancestry=="African")
a <- binsreg(racex$race_w3_bl, racex$value, by=racex$female, 
             polyreg=6, nbins=50, legendTitle = "") 
b <- binsreg(racex$race_w3_bl, racex$value, by=racex$gene1, 
             polyreg=6, nbins=50, legendTitle = "") 
c <- binsreg(racex$race_w3_bl, racex$value, by=racex$noneng, 
             polyreg=6, nbins=50, legendTitle = "") 
d <- binsreg(racex$race_w3_bl, racex$value, by=racex$ses, 
             polyreg=6, nbins=50, legendTitle = "") 
fig1 <- a$bins_plot +
  ylab("") +xlab("")+theme_few()+
  theme(legend.position="bottom")
fig2 <- b$bins_plot +
  ylab("") +xlab("")+theme_few()+
  theme(legend.position="bottom")
fig3 <- c$bins_plot +
  ylab("") +xlab("% genetic ancestry")+theme_few()+
  theme(legend.position="bottom")
fig4 <- d$bins_plot +
  ylab("") +xlab("% genetic ancestry")+theme_few()+
  theme(legend.position="bottom")

fig <- (fig1 + fig2) / (fig3+fig4) +  
  plot_annotation(title = 'Racial identity: black - african ancestry',
                  theme = theme(plot.title = element_text(size = 14)))
ggsave(fig,height=6,width=9,dpi=200, filename="binnedplot_black_hetero.pdf",  family = "Helvetica")

######################################################################
# Heterogeneity among asians
######################################################################
racex <- race %>% 
  filter(ancestry=="Asian")
a <- binsreg(racex$race_w3_as, racex$value, by=racex$female, 
             polyreg=6, nbins=50, legendTitle = "") 
b <- binsreg(racex$race_w3_as, racex$value, by=racex$gene1, 
             polyreg=6, nbins=50, legendTitle = "") 
c <- binsreg(racex$race_w3_as, racex$value, by=racex$noneng, 
             polyreg=6, nbins=50, legendTitle = "") 
d <- binsreg(racex$race_w3_as, racex$value, by=racex$ses, 
             polyreg=6, nbins=50, legendTitle = "") 
fig1 <- a$bins_plot +
  ylab("") +xlab("")+theme_few()+
  theme(legend.position="bottom")
fig2 <- b$bins_plot +
  ylab("") +xlab("")+theme_few()+
  theme(legend.position="bottom")
fig3 <- c$bins_plot +
  ylab("") +xlab("% genetic ancestry")+theme_few()+
  theme(legend.position="bottom")
fig4 <- d$bins_plot +
  ylab("") +xlab("% genetic ancestry")+theme_few()+
  theme(legend.position="bottom")

fig <- (fig1 + fig2) / (fig3+fig4) +  
  plot_annotation(title = 'Racial identity: asian - asian ancestry',
                  theme = theme(plot.title = element_text(size = 14)))
ggsave(fig,height=6,width=9,dpi=200, filename="binnedplot_asian_hetero.pdf",  family = "Helvetica")

######################################################################
# Heterogeneity among hispanics 1
######################################################################
racex <- race %>% 
  filter(ancestry=="African")
a <- binsreg(racex$race_w3_hs, racex$value, by=racex$female, 
             polyreg=6, nbins=50, legendTitle = "") 
b <- binsreg(racex$race_w3_hs, racex$value, by=racex$gene1, 
             polyreg=6, nbins=50, legendTitle = "") 
c <- binsreg(racex$race_w3_hs, racex$value, by=racex$noneng, 
             polyreg=6, nbins=50, legendTitle = "") 
d <- binsreg(racex$race_w3_hs, racex$value, by=racex$ses, 
             polyreg=6, nbins=50, legendTitle = "") 
fig1 <- a$bins_plot +
  ylab("") +xlab("")+theme_few()+
  theme(legend.position="bottom")
fig2 <- b$bins_plot +
  ylab("") +xlab("")+theme_few()+
  theme(legend.position="bottom")
fig3 <- c$bins_plot +
  ylab("") +xlab("% genetic ancestry")+theme_few()+
  theme(legend.position="bottom")
fig4 <- d$bins_plot +
  ylab("") +xlab("% genetic ancestry")+theme_few()+
  theme(legend.position="bottom")

fig <- (fig1 + fig2) / (fig3+fig4) +  
  plot_annotation(title = 'Racial identity: hispanic - african ancestry',
                  theme = theme(plot.title = element_text(size = 14)))
ggsave(fig,height=6,width=9,dpi=200, filename="binnedplot_hisp_hetero1.pdf",  family = "Helvetica")

######################################################################
# Heterogeneity among hispanics 2
######################################################################
racex <- race %>% 
  filter(ancestry=="American")
a <- binsreg(racex$race_w3_hs, racex$value, by=racex$female, 
             polyreg=6, nbins=50, legendTitle = "") 
b <- binsreg(racex$race_w3_hs, racex$value, by=racex$gene1, 
             polyreg=6, nbins=50, legendTitle = "") 
c <- binsreg(racex$race_w3_hs, racex$value, by=racex$noneng, 
             polyreg=6, nbins=50, legendTitle = "") 
d <- binsreg(racex$race_w3_hs, racex$value, by=racex$ses, 
             polyreg=6, nbins=50, legendTitle = "") 
fig1 <- a$bins_plot +
  ylab("") +xlab("")+theme_few()+
  theme(legend.position="bottom")
fig2 <- b$bins_plot +
  ylab("") +xlab("")+theme_few()+
  theme(legend.position="bottom")
fig3 <- c$bins_plot +
  ylab("") +xlab("% genetic ancestry")+theme_few()+
  theme(legend.position="bottom")
fig4 <- d$bins_plot +
  ylab("") +xlab("% genetic ancestry")+theme_few()+
  theme(legend.position="bottom")

fig <- (fig1 + fig2) / (fig3+fig4) +  
  plot_annotation(title = 'Racial identity: hispanic - american ancestry',
                  theme = theme(plot.title = element_text(size = 14)))
ggsave(fig,height=6,width=9,dpi=200, filename="binnedplot_hisp_hetero2.pdf",  family = "Helvetica")

######################################################################
# Modal
######################################################################
afr <- dta %>% 
  left_join(link,by = "AID") %>% 
  dplyr::select(gid=GID,aid=AID,everything()) %>% 
  filter(is.na(gid)==F) %>% 
  filter(amr < 0.05) %>% 
  filter(asa < 0.05) %>% 
  mutate(decile = ntile(afr, 10)) %>% 
  dplyr::select(starts_with("race_"),decile) %>% 
  group_by(decile) %>% 
  summarise_all(list(mean)) %>% 
  dplyr::select(-7) %>% 
  pivot_longer(c(2:6), names_to = "race", values_to = "value") %>% 
  group_by(decile) %>% 
  mutate(max = max(value)) %>% 
  filter(value == max) %>% 
  dplyr::select(decile,race,modal=value)
  
