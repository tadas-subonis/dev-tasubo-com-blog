# Intro

[Main URL](https://dev.tasubo.com/)

## serve command
```
jekyll serve
```

## Some junk

```
		{% unless post.next %}
			<h3>{{ post.date | date: '%Y' }} &#172;</h3>
		{% else %}
			{% capture year %}{{ post.date | date: '%Y' }}{% endcapture %}
			{% capture nyear %}{{ post.next.date | date: '%Y' }}{% endcapture %}
			{% if year != nyear %}
				<h3>{{ post.date | date: '%Y' }} &#172;</h3>
			{% endif %}
		{% endunless %}
```