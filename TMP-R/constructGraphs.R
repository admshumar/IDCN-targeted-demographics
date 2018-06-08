jobreport_basic <- function(table, N)
{
  #Group
  table <- table %>%
    group_by(Education, Desired) %>%
    summarize(n())
  
  #Order
  table <- arrange(table, desc(`n()`))
  
  #Response label
  response_count <- sum(table$`n()`)
  
  #Sample size label
  samplesize <- paste("(N = ", sum(table$`n()`), ")", sep="")
  
  #Basic barplot
  ggplot(table[which(table$`n()`>N),], aes(x=reorder(Desired,-`n()`), y=`n()`)) +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      plot.margin = margin(0.5,0.5,1,3, "cm")
    ) +
    xlab(paste("Number of Active Members: ", member_count, "\n", "Number of Responses: ", response_count, sep="")) +
    ylab("Number of IDCN Members") +
    ggtitle(paste(desired_title("Industries"), "\n",today, sep = "")
    )+
    geom_text(aes(label=`n()`), position="stack", vjust=1) +
    geom_col()
}

jobreport_basic(A,2)

#Stacked barplot of IDCN Copenhagen's desired job placements.
jobreport_stacked <- function(table, N)
{  
  #Group
  table <- table %>%
    group_by(Education, Desired) %>%
    summarize(n())
  
  #Order
  table <- arrange(table[which(table$`Desired`!="(No Response)" & table$`n()`>N & table$Education!="(No Response)" & table$Education!="High School" & table$Education!="Other"), ], desc(`n()`))
  
  #Response label
  response_count <- sum(table$`n()`)
  
  #Sample size label
  samplesize <- paste("(N = ", sum(table$`n()`), ")", sep="")
  
  #Stacked barplot
  ggplot(table, aes(fill=Education, x=reorder(Desired,-`n()`), y=`n()`, label = `n()`)) +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      legend.position = "left"
    ) +
    xlab(paste("Number of Active Members: ", member_count, sep="")) +
    ylab("Number of IDCN Members") +
    ggtitle(paste(desired_title("Job Fields"), "\n",today, sep = "")
    )+
    geom_col()+
    geom_text(size=5, position = position_stack(vjust = 0.5))
}

print(jobreport_stacked(A,1))
print(jobreport_stacked(A1,1))

#Grouped barplot of IDCN Copenhagen's desired job placements.
jobreport_grouped <- function(table, N)
{
  #Group
  table <- table %>%
    group_by(Education, Desired) %>%
    summarize(n())
  
  #Order
  table <- arrange(table, desc(`n()`))
  
  #Response label
  response_count <- sum(table$`n()`)
  
  #Sample size label
  samplesize <- paste("(N = ", sum(table$`n()`), ")", sep="")
  
  #Grouped barplot
  ggplot(table[which(table$`n()`>N),], aes(fill=Education, x=reorder(Desired,-`n()`), y=`n()`)) +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1), 
      legend.position = "left"
    ) +
    xlab(paste("Number of Active Members: ", member_count, "\n", "Number of Responses: ", response_count, sep="")) +
    ylab("Number of IDCN Members") +
    ggtitle(paste(desired_title("Professional Areas"), "\n",today, sep = "")
    )+
    geom_col(position="dodge")  
}

print(jobreport_grouped(A,1))
print(jobreport_grouped(A1,1))

#Restricted barplot of IDCN Copenhagen's desired job placements.
jobreport_restricted <- function(table, N)
{  
  #Group
  table <- table %>%
    group_by(Education, Desired) %>%
    summarize(n())
  
  #Order
  table <- arrange(table, desc(`n()`))
  
  #Response label
  response_count <- sum(table$`n()`)
  
  #Restricted grouped barplot
  ggplot(table[which(table$`n()`>N),], 
         aes(fill=Education, x=reorder(Desired,-`n()`), y=`n()`)) +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1), 
      legend.position = "left"
    ) +
    xlab(paste("Number of Active Members: ", member_count, "\n", "Number of Responses: ", response_count, sep="")) +
    ylab("Number of IDCN Members") +
    ggtitle(paste(desired_title("Professional Areas"), "\n",today, sep = "")
    )+
    geom_bar(position="dodge", stat="identity") 
}

print(jobreport_restricted(A,1))
print(jobreport_restricted(A1,1))

jobreport_fieldplot <- function(table, string)
{  
  #Group
  table <- table %>%
    group_by(Education, Desired) %>%
    summarize(n())
  
  #Order
  table <- arrange(table, desc(`n()`))
  
  #Restricted table
  r_table <- table[which(table$Desired==string),]
  
  #Sample size label
  response_count <- sum(r_table$`n()`)
  
  #Restricted grouped barplot
  ggplot(
    r_table, 
    aes(
      fill=Education, 
      x=reorder(Desired,-`n()`), 
      y=`n()`,
      label=`n()`
    )
  ) +
    themeIDCN_counts() +
    xlab(paste("Number of Active Members: ", response_count, sep="")) +
    ylab("Number of IDCN Members") +
    ggtitle(
      paste(fieldplot_title(string),"\n",today, sep = "")
    ) +
    geom_text(position = position_dodge(width=0.9),
              size = 7,
              aes(
                colour = Education, 
                y=2+`n()`, 
                label=`n()`,
                hjust=0.5) #hjust=0.5 corresponds to centered text
    ) +
    #annotate(size = 5, "text",x = Inf,y = Inf,label = samplesize, hjust = 1.5, vjust = 1.5) +
    geom_bar(aes(fill=Education), position=position_dodge(width=0.9), stat="identity")
  #geom_col() 
}