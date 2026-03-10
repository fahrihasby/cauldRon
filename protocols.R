# Define various protocols with multiple mixes
# QIAseq miRNA
protocol_library <- list(
  "Genotyping PCR" = list(
    "PCR Master Mix" = data.frame(
      Reagent = c("2x Green Mix", "FWD Primer (10uM)", "REV Primer (10uM)", "Nuclease-Free Water"),
      Vol = c(12.5, 0.5, 0.5, 9.5)
    )
  ),
  "RT-qPCR (2-Step)" = list(
    "RT Mix (Step 1)" = data.frame(
      Reagent = c("5x RT Buffer", "RT Enzyme Mix", "Random Hexamers", "RNAse Inhibitor", "Water"),
      Vol = c(4.0, 1.0, 1.0, 0.5, 3.5)
    ),
    "qPCR Mix (Step 2)" = data.frame(
      Reagent = c("2x SYBR Master", "Primer Mix (10uM)", "Water"),
      Vol = c(10.0, 1.2, 3.8)
    )
  )
)
