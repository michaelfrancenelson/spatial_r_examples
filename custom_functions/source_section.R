if(FALSE)
{
  # test case
    filename = here("point_patterns", "spatstat_k_l_functions", "marked_l_function_01.R")
  section = "r_help_example"
  aaa = source_section(filename, section)
  aaa
}

source_section = function(filename, section_name, eval_code = TRUE, return_expr)
{
  file_lines = readLines(filename)
  script_file_err = paste0("' not found in script file '", filename, "'")
  
  section_starts = which(grepl(paste0("#\\s-{4}.", section_name), file_lines, perl = TRUE))
  
  err = function(msg)
  {
    print(msg)
    return(NULL)
  }
  
  if(length(section_starts) == 0) err(paste0("Section anchor '", section_name, script_file_err))
  if(length(section_starts) > 1) err(paste0("Multiple section anchors with name '", section_name, script_file_err))
  
    end_found = FALSE
    section_end = section_starts
    for (i in section_starts:length(file_lines))
    {
      if (grepl("^\\}", file_lines)[i])
      {
        end_found = TRUE
        section_end = i
        break
      }
    }
  
  if (!end_found) err(paste0("No closing brace for section '", section_name, script_file_err))
  
  expr = paste0(file_lines[section_starts:(section_end - 1)], collapse = "\n")
  if(eval_code) eval(parse(text = expr))
  invisible(expr)
}
