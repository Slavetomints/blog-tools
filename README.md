# blog-tools

[![forthebadge](https://forthebadge.com/images/badges/made-with-ruby.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)](https://forthebadge.com)

![License](https://img.shields.io/github/license/slavetomints/blog-tools)
![Gem Version](https://img.shields.io/gem/v/blog-tools?label=gem%20version)
![Gem Total Downloads](https://img.shields.io/gem/dt/blog-tools?label=downloads@total)
![Gem Downloads (for latest version)](https://img.shields.io/gem/dtv/blog-tools)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=shields)](http://makeapullrequest.com)


*This readme template was borrowed from [`athityakumar/colorls`](https://github.com/athityakumar/colorls)*  

# Table of contents

- [Usage](#usage)
  - [Subcommands](#subcommands)
    - [`config`](#config)
    - [`generate`](#generate)
    - [`lists`](#lists)
    - [`help`](#help)
- [Installation](#installation)
- [Updating](#updating)
- [Uninstallation](#uninstallation)
- [License](#license)

# Usage
## Subcommands
### Config
> Under development, will be functional in future updates!
### Generate

This is the subcommand used for generating posts from templates. These are the subcommands for this subcommand:
- `post [TITLE]`
  - If called without flags, it uses the defaults set in `~/.config/blog-tools/config.yml`
  - ```
    ❯ blog-tools generate post example
    [✓] Post generated at example.md
    ```
  - `--template`
    -  Used to specify a path to a template file. Templates are stored in `~/.config/blog-tools/templates/`. At the moment the tool only supports ERB templates with the following variables: `title`, `date`, `author`, `tags`, `content`. 
    - *Do note there is not currently a way to change the date upon generation from anything but the current day.*
    - If not specified it defaults to the tags in the config file.
    - ```
      ❯ blog-tools generate post example --template post.md
      [✓] Post generated at example.md
      ```
  - `--tags`
    - Used to specify the tags for the blog post. Enter them separated by spaces.
    - If not specified it defaults to the tags in the config file.
    - ```
       ❯ blog-tools generate post example --tags example-1 example-2
      [✓] Post generated at example.md
      ```
  - `--author`
    - Used to specify the author of the blog post.
    - If not used it defaults to the author in the config file.
    - ```
       ❯ blog-tools generate post example --author slavetomints
      [✓] Post generated at example.md
      ```
  - `--output`
    - Used to specify the output location for the blog post.
    - If not specified it defaults to the current directory.
    - ```
      ❯ blog-tools generate post example --output ~/documents
      [✓] Post generated at /home/slavetomints/documents/example.md
      ```
  - `--content`
    - Used to specify the content of the blog post.
    - If not specified it defaults to nothing. 
    - ```
      ❯ blog-tools generate post example --content ~/documents/blog-post.md
      [✓] Post generated at example.md
      ```

### Lists
- `add LIST POST`
  - adds a post to a list
  - ```
    ❯ blog-tools lists add test example
    [✓] Added example to test list
    ```
- `create NAME`
  - creates a list
  - ```
    ❯ blog-tools lists create test
    [✓] Created list: test
    ```
- `delete LIST`
  - deletes the list after getting confirmation
  - ```
    ❯ blog-tools lists delete test
    [?] Are you sure you want to delete the 'test' list?
    [?] This action cannot be undone. Proceed? (y/N)
    > y
    [✓] Deleted 'test' list
    ```
- `list LIST`
  - If called without flags, it shows every post in the list.
  - ```
    ❯ blog-tools lists list example
    EXAMPLE
    - example-post-1
    - example-post-2
    - example-post-3
    - example-post-4
    - example-post-5
    ```
  - `--completed`
    - Shows only the posts that are completed.
    - ```
      ❯ blog-tools lists list example --completed
      EXAMPLE
      - example-post-1
      - example-post-3
      ```
  - `--in-progress`
    - Shows only the posts that are in progress
    - ```
      ❯ blog-tools lists list example --in-progress
      EXAMPLE
      - example-post-2
      ```
  - `--status`
    - Shows a status icon next to the posts
    - ```
      ❯ blog-tools lists list example --status
      EXAMPLE
      - [✓] example-post-1
      - [~] example-post-2
      - [✓] example-post-3
      - [ ] example-post-4
      - [ ] example-post-5
      ```
    - `[✓]` means complete, `[~]` means in progress, and `[ ]` means not started.
- `remove LIST POST`
  - Removes the post from the list.
  - ```
    ❯ blog-tools lists remove example example-post-1
    [?] Are you sure you want to delete the post 'example-post-1'?
    [?] This action cannot be undone. Proceed? (y/N)
    > y
    [✓] Deleted 'example-post-1' post
    ```
- `update LIST POST`
  - *If called without flags, a warning will show.*
  - `--completed`
    - Marks a post as complete
    - ```
      ❯ blog-tools lists update example example-post-1 --completed
      [✓] Marked 'example-post-1' as complete
      ```
  - `--in-progress`
    - Marks a post as in progress.
    - ```
      ❯ blog-tools lists update example example-post-2 --in-progress
      [✓] Marked 'example-post-2' as in progress
      ```
  - `--path`
    - Adds the path to where the post content is.
    - ```
      ❯ blog-tools lists update example example-post-1 --path ~/documents/writeup.md
      The post content is located at: /home/slavetomints/documents/writeup.md
      ```
  - `--tags`
    - Adds tags to the post
    - ```
      ❯ blog-tools lists update example example-post-3 --tags 1 2 3
      Added the following tags to the post: ["1", "2", "3"]
      ```

### Help

Calling just the help subcommand shows basic information about the other subcommands, calling `help [SUBCOMMAND]` gives more detail on that specific subcommand.

```
❯ blog-tools help
Commands:
  blog-tools config          # Configure blog-tools
  blog-tools generate        # Create a new post
  blog-tools help [COMMAND]  # Describe available commands or one specific command
  blog-tools lists           # Lists tools
```

```
❯ blog-tools help lists
Commands:
  blog-tools lists add LIST POST     # Add a post to a list
  blog-tools lists create NAME       # Create a list
  blog-tools lists delete LIST       # Delete a list
  blog-tools lists help [COMMAND]    # Describe subcommands or one specific subcommand
  blog-tools lists list LIST         # View all posts in a list
  blog-tools lists remove LIST POST  # Remove a post from a list
  blog-tools lists update LIST POST  # Update the status of a blog post idea
```

# Installation

[(Back to top)](#table-of-contents)

1. Install Ruby (I recommend using [`rbenv`](https://github.com/rbenv/rbenv) to install Ruby)
2. Install the [blog-tools](https://rubygems.org/gems/blog-tools/) ruby gem with `gem install blog-tools`.

4. Start using `blog-tools`!

# Updating

[(Back to top)](#table-of-contents)

Want to update to the latest version of `blog-tools`?

```sh
gem update blog-tools
```

# Uninstallation

[(Back to top)](#table-of-contents)

Want to uninstall the gem? If there was an issue with the gem, please feel free to open an issue regarding how we can enhance `blog-tools`.

```sh
gem uninstall blog-tools
```

# License

[(Back to top)](#table-of-contents)


MIT License

Copyright (c) 2025 Slavetomints

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.