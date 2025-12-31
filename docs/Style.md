# Style

!!! warning "REMOVE THIS!"
    This is a completely temporary article that is used for a refrence when styling the website. This needs to be removed!

This is an article that exists to test the theme styling! So lets get started.

# Header 1
## Header 2
### Header 3

!!! note
    This is a note!

!!! abstract
    This is an abstract!

!!! info
    This is a info!

!!! tip
    This is a tip!

!!! success
    This is a success!

!!! question
    This is a question!

!!! warning
    This is a warning!

!!! failure
    This is a failure!

!!! danger
    This is a danger!

!!! bug
    This is a bug!

!!! example
    This is an example!


!!! quote
    This is a quote!

!!! do
    do this, its correct!

!!! dont
    don't do this, its wrong!

??? note
    This is collapsible!

[Button!](#){ .md-button }

## Code
```lua title="Test.luau" linenums="1" hl_lines="5 6 7 8 9"
print("wow")
--This is a comment.
local var = 2

function foo(one, two)
    if one == two then
        return true, "Yay"
    end
end

print(foo(2, 2))
```