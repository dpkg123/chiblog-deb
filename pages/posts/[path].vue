<script setup>
import Icon from '@/components/Icon'

import incposts from '@/mocks/posts'
import setting from '@/mocks/settings'

const $route = useRoute()
const $store = useAlldata()
const $router = useRouter()

const props = {
  path: $route.params.path || ''
}
let post = reactive({
  content: ''
})
let posts = reactive({})

let settings = reactive({})
const postComments = ref(0)
let china = false

function renderTime(time) {
  const currentTime = new Date()
  const relTime = new Date(time * 1000)
  const offset = Math.floor((currentTime.getTime() - relTime.getTime()) / 1000)
  if (offset < 60 && offset > 0) {
    return offset + '秒前'
  } else if (offset > 60 && offset < 60 * 60) {
    return Math.floor(offset / 60) + '分钟前'
  } else if (offset > 60 * 60 && offset < 60 * 60 * 24) {
    return Math.floor(offset / (60 * 60)) + '小时前'
  } else if (offset > 60 * 60 * 24 && offset < 60 * 60 * 24 * 30) {
    return Math.floor(offset / (60 * 60 * 24)) + '天前'
  } else if (offset > 60 * 60 * 24 * 30 && offset < 60 * 60 * 24 * 30 * 12) {
    return Math.floor(offset / (60 * 60 * 24 * 30)) + '个月前'
  } else if (offset > 60 * 60 * 24 * 30 * 12 && offset < 60 * 60 * 24 * 30 * 12 * 3) {
    return Math.floor(offset / (60 * 60 * 24 * 30 * 12)) + '年前'
  } else {
    return relTime.getFullYear() + '-' + (relTime.getMonth() + 1) + '-' + relTime.getDate()
  }
}

// methods
const isCN = computed(() => {
  return $store.value.isCN
})

// mounted
// check whether this application in production mode.
if ($store.value.model === 'production') {
  posts = $store.value.all.posts
  settings = $store.value.all.settings
  // postcomments = comments.filter((comment) => comment.to === props.pid).length
} else {
  posts = incposts
  settings = setting
  // comments = mockcomments
}

//find posts
if (posts.find((post) => post.path === props.path) === undefined) {
  $router.push('/error/404.html')
} else {
  post = posts.find((post) => post.path === props.path)
  // checkCN()
  // ignore china checks now
  china = true
}


if (post.banner === undefined) {
  if (settings.site.articleimage.enabled) {
    post.banner = settings.site.articleimage.images[Math.floor(Math.random() * settings.site.articleimage.images.length)]
  } else {
    post.banner = ''
  }
}

useHead({
  title: post.title + ' - ' + settings.site.title,
  meta: [
    {
      name: 'description',
      content:
        post.desc +
        ' - 本文首发于' +
        settings.site.title +
        ',由' +
        post.author +
        '撰写，版权所有。'
    },
    {
      name: 'twitter:image:src',
      content: post.banner,
    },
    {
      name: 'twitter:card',
      content: 'summary_large_image'
    },
    {
      name: 'twitter:title',
      content: post.title + ' - ' + settings.site.title
    },
    {
      name: 'twitter:description',
      content: post.desc + ',由' + post.author + '撰写 - Engined by chiblog'
    },
    {
      name: 'twitter:site',
      content: '@' + settings.site.author.name
    },
    {
      name: 'twitter:creator',
      content: '@' + settings.site.author.name
    }
  ]
})

const reltime = computed(() => {
  return renderTime(post.time)
})
const updtime = computed(() => {
  return renderTime(post.updtime)
})

function renderNumber(num) {
  if (num > 100000) {
    return Math.round((num / 10000) * 100) / 100 + 'w'
  } else if (num > 1000) {
    return Math.round((num / 10000) * 100) / 10 + 'k'
  } else {
    return num
  }
}

</script>
<template>
  <ImageCard :img="post.banner">
    <h1>{{ post.title }}</h1>
    <div id="infoset">
      <div><Icon name="account" /><span><nuxt-link :to="'/author/' + post.author">{{ post.author }}</nuxt-link></span></div>
      <div><Icon name="clockoutline" /><span>{{ reltime }}</span></div>
      <div><Icon name="accountarrowup" /><span>{{ updtime }}</span></div>
      <div v-if="settings.site.comment.backend.type === 'chicomment-simple'"><Icon name="comment" />{{ postComments }}</div>
      <div v-if="settings.site.textcount.article !== undefined ? settings.site.textcount.article : true"><Icon name="textCount" /><span>{{ renderNumber(post.content.length) }}字</span></div>
      <div><Icon name="book" /><span><nuxt-link :to="'/category/' + post.category">{{ post.category !== undefined ? post.category : '未分类' }}</nuxt-link></span></div>
      <div><Icon name="views" /><span id="busuanzi_value_page_pv">加载中</span></div>
    </div>
    <div>
      <Content :content="post.content" />
      <p v-if="post.tags !== undefined" id="tags" style="font-size: 18px">
        <Icon name="tag" />
        <span id="list">
          <span>
            <nuxt-link
              v-for="i in post.tags"
              :key="i"
              :to="'/tag/' + i"
              class="likea">
              <span class="tag">{{ i }}</span>
            </nuxt-link>
          </span>
        </span>
      </p>
      <p v-else style="font-size: 18px;"><Icon name="tag" />没有标签！</p>
    </div>
  </ImageCard>
  <div id="changes">
    <div></div>
    <PureCard id="previous-post">
      <h2>上一篇文章</h2>
      <div v-if="posts.indexOf(post) + 1 > posts.length">
        <h3>没有啦~</h3>
      </div>
      <div v-else>
        <nuxt-link :to="'/posts/' + posts[posts.indexOf(post) + 1].path">{{
            posts[posts.indexOf(post) + 1].title
          }}</nuxt-link>
      </div>
    </PureCard>
    <div></div>
    <PureCard id="next-post">
      <h2>下一篇文章</h2>
      <!-- {{ (posts.indexOf(post) - 1) }} -->
      <div v-if="posts.indexOf(post) - 1 <= 0">
        <h3>没有啦~</h3>
      </div>
      <div v-else>
        <nuxt-link :to="'/posts/' + posts[posts.indexOf(post) - 1].path">{{
            posts[posts.indexOf(post) - 1].title
          }}</nuxt-link>
      </div>
      <!-- <nuxt-link :to="'/posts/' + posts[posts.indexOf(post) - 1].path">{{ posts[posts.indexOf(post) - 1].title }}</nuxt-link> -->
    </PureCard>
    <div></div>
  </div>
  <PureCard id="comments">
    <Comments :pid="post.id + ''" />
  </PureCard>
</template>
<style lang="scss" scoped>
a {
  transition: color 200ms ease-in-out;
}
#content img {
  width: 100%;
}
#infoset {
  display: flex;
  padding: 4px;
  @media screen and (min-width: 1024px) {
    justify-content: space-between;
  }
  flex-wrap: wrap;
  div {
    display: flex;
    justify-content: center;
    font-size: 18px;
    padding: 4px;
  }
}
.click {
  cursor: pointer;
}
#changes {
  display: grid;
  @media screen and (min-width: 768px) {
    grid-template-columns: 8px 1fr 8px 1fr 8px;
  }
  @media screen and (max-width: 768px) {
    grid-template-columns: 1fr;
  }
}
// #post-container {
//   border-radius: 4px;
//   backdrop-filter: blur(5px);
//   border: 1px solid #000;
//   margin: 4px;
//   box-shadow: #eee 2px;
//   background-color: rgba(0,0,0,0);
//   padding: 2px;
// }

#tags {
  display: flex;
  //flex-wrap: wrap;
}
span.tag {
  margin: 4px;
}
</style>
<style>
a,
a:hover,
a:active,
a:link {
  text-decoration: none;
  color: blue;
}
a:hover {
  color: cyan;
}
</style>
