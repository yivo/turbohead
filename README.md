# turbohead

### step 1
Write helper which generates meta and returns array of hashes:
```ruby
  def meta
    l = []
    l << { charset: 'UTF-8' }
    l << { 'http-equiv' => 'Content-Type', content: 'text/html; charset=UTF-8' }
    l << { 'http-equiv' => 'X-UA-Compatible', content: 'IE=edge'}
    l << { name: 'description', content: page_description }
    l << { name: 'keywords', content: page_keywords }
    # ...
    l
  end
```

Write helper which generates html for meta:
```ruby
  def meta_tags
    buffer = []
    meta.each do |attrs|
      if attrs.except(:name).values.any?(&:present?)
        buffer << tag('meta', attrs)
      end
    end
    buffer.join('').html_safe
  end
```

### step 2
Put meta tags in your markup:
```slim
doctype html
head
  title turbohead
  ==meta_tags
```

### step 3
Put turbohead invocation in your markup (after your JavaScripts):
```slim
body
  / Put this in the body after your JavaScripts:
  javascript:
    turbohead(#{{Oj.dump(meta)}});
```
If you are not using `Oj` then change code to `meta.to_json`.