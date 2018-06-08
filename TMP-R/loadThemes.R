#Theme for barplots topped with values. These are useful for displaying data about the part of the membership that is interested in a given sector of the economy.

themeIDCN <- function(){
  theme(
    axis.text.x = element_text(colour = "white", size=rel(1.5)),
    axis.title.x = element_text(colour = "white", size=rel(1.5)),
    axis.text.y = element_text(colour = "black", size=rel(1.5)),
    axis.title.y = element_text(colour = "black", size=rel(1.5)),
    #axis.title.y = element_text(colour = "blue", angle=45),
    panel.background = element_rect(fill="gray97"),
    panel.grid.minor = element_line(colour = "white"),
    panel.grid.major = element_line(colour = "white"),
    plot.background = element_rect(fill="white"),
    plot.title = element_text(colour = "black", size=rel(1.7)),
    legend.position = "left"
  )
}

themeIDCN_counts <- function(){
  theme(
    axis.text.x = element_text(colour = "white", size=rel(1.5)),
    axis.title.x = element_text(colour = "black", size=rel(1.5)),
    axis.text.y = element_text(colour = "black", size=rel(1.5)),
    axis.title.y = element_text(colour = "black", size=rel(1.5)),
    #axis.title.y = element_text(colour = "blue", angle=45),
    panel.background = element_rect(fill="gray97"),
    panel.grid.minor = element_line(colour = "white"),
    panel.grid.major = element_line(colour = "white"),
    plot.background = element_rect(fill="white"),
    plot.title = element_text(colour = "black", size=rel(1.7)),
    legend.position = "left"
  )
}