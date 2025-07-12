# script to order GitHub Actions to update my birthday in the About page

library(yaml)

# Set your birth year
birth_year <- 1999  # <-- change this to your actual birth year
current_age <- as.integer(format(Sys.Date(), "%Y")) - birth_year

# Create each paragraph as an element in a character vector
intro_paragraphs <- c(
  
  sprintf("I am Karthik Thrikkadeeri (alias Trick D. Eerie), a %d-year-old from Kerala, India. I am an ecologist, which means that I am interested in organisms and their relationships with each other and with the environment, and that I often spend my days thinking about various patterns in nature. It also means that I have a close relationship with numbers, often messy.", current_age),
  
  "Although I don’t know a fair many languages (and am not necessarily passionate about learning many), I do love how languages work. Consequently, I tend to get excited over small things like ingenious wordplay and writing with multiple layers to it. Irrespective of this though, I believe that there is immense power that writing holds. Lately, I have started to take my own writing more seriously and to integrate it better into my life.",
  
  "I love all things wild and free! Nature to me is endlessly exciting, intriguing and calming. I don’t *get lost* in nature as often as I’d like, and instead most often find myself looking and listening for birds (birding!). I am also obsessed with the Road, and more generally I tend to satiate my freeness- and lostness-cravings with travel, mostly preferring to go off the trodden path. As such, birding and travel for me have become inextricably linked.",
  
  "I consider myself to be a minimalist, and lament how everyone consciously or otherwise madly chases after *more*. I often find myself wistful for the “good old days”---times before even mine, but familiar (and alluring) to me almost as legend---and pondering on how it all would be if things were to change.",
  
  "If you’re interested in seeing more of my other exploits online, do check out my profiles on [eBird](https://ebird.org/profile/ODQxNTky/world), where I have all my birding data (which also contributes to science!), [iNaturalist](https://www.inaturalist.org/people/337978), where I keep all non-bird data, and [The Storygraph](https://app.thestorygraph.com/profile/kartrick), where I track and review books."
  
)

# Join the paragraphs with a blank line between each
new_intro <- paste(intro_paragraphs, collapse = "\n\n")

# Read index.md
lines <- readLines("content/about/main/index.md")  # Adjust path if needed
yaml_start <- which(lines == "---")[1]
yaml_end <- which(lines == "---")[-1][1]

# Parse YAML block
yaml_lines <- lines[(yaml_start + 1):(yaml_end - 1)]
yaml_obj <- yaml.load(paste(yaml_lines, collapse = "\n"))

# Update intro field
yaml_obj$intro <- new_intro

# Write updated YAML back
new_yaml <- as.yaml(yaml_obj)

# Reconstruct the file
new_file <- c("---", new_yaml, "---", lines[(yaml_end + 1):length(lines)])
writeLines(new_file, "content/about/main/index.md")
