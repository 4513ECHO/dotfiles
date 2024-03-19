;; extends
(git_diff_header) @type

[
  (git_old_mode)
  (git_new_mode)
  (git_deleted_file_mode)
  (git_new_file_mode)
  (git_copy_from)
  (git_copy_to)
  (git_rename_from)
  (git_rename_to)
  (git_similarity_index)
  (git_dissimilarity_index)
  (git_index)
] @preproc

(from_file_line) @diff.minus
(to_file_line) @diff.plus

(line_deleted "-" @diff.minus @markup.strong)
(line_deleted (body) @diff.minus)

(line_added "+" @diff.plus @markup.strong)
(line_added (body) @diff.plus)
