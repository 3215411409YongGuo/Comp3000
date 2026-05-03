<template>
  <div :class="classObj" class="app-wrapper">
    <div v-if="device==='mobile'&&sidebar.opened" class="drawer-bg" @click="handleClickOutside" />
    <sidebar class="sidebar-container" />
    <div class="main-container">
      <div :class="{'fixed-header':fixedHeader}">
        <navbar />
      </div>
      <app-main />
    </div>
    
    <div class="coze-bot">
      <div 
        class="bot-icon" 
        @click="toggleBot"
        :class="{ 'active': showBot }"
      >
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="10"></circle>
          <path d="M8 14s1.5 2 4 2 4-2 4-2"></path>
          <line x1="9" y1="9" x2="9.01" y2="9"></line>
          <line x1="15" y1="9" x2="15.01" y2="9"></line>
        </svg>
      </div>
      
      <div class="bot-dialog" v-if="showBot">
        <div class="dialog-header">
          <h3>Intelligent Assistant</h3>
          <button class="close-btn" @click="showBot = false">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <line x1="18" y1="6" x2="6" y2="18"></line>
              <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
          </button>
        </div>
        
        <div class="dialog-body">
          <div class="message-history" v-if="messages.length > 0">
            <div 
                v-for="(message, index) in messages" 
                :key="index"
                :class="['message', message.role]"
            >
                <div class="message-header">
                    <span class="message-role">{{ message.role === 'user' ? 'Your' : 'Agent' }}</span>
                    <span class="message-time">{{ message.time }}</span>
                </div>
                <div 
                    class="message-content" 
                    v-if="message.role === 'assistant'"
                    v-html="parseMarkdown(message.content)"
                ></div>
                <div 
                    class="message-content" 
                    v-else
                >{{ message.content }}</div>
            </div>
          </div>
          
          <div class="input-area">
              <input 
                  type="text" 
                  v-model="userInput" 
                  placeholder="Please enter your question...."
                  @keyup.enter="sendMessage"
                  :disabled="loading"
              />
              <button @click="sendMessage" :disabled="loading || !userInput.trim()">
                  {{ loading ? 'sending...' : 'send' }}
              </button>
          </div>
        </div>
        
        <div v-if="error" class="error">
            <h3>Error：</h3>
            <p>{{ error }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { Navbar, Sidebar, AppMain } from './components'
import ResizeMixin from './mixin/ResizeHandler'
import * as marked from 'marked'
import Vue from 'vue'

export default {
  name: 'Layout',
  components: {
    Navbar,
    Sidebar,
    AppMain
  },
  mixins: [ResizeMixin],
  data() {
    return {
      showBot: false,
      loading: false,
      userInput: '',
      messages: [],
      error: '',
      apiClient: null
    }
  },
  computed: {
    sidebar() {
      return this.$store.state.app.sidebar
    },
    device() {
      return this.$store.state.app.device
    },
    fixedHeader() {
      return this.$store.state.settings.fixedHeader
    },
    classObj() {
      return {
        hideSidebar: !this.sidebar.opened,
        openSidebar: this.sidebar.opened,
        withoutAnimation: this.sidebar.withoutAnimation,
        mobile: this.device === 'mobile'
      }
    }
  },
  mounted() {
    // Initialize the Coze API
    this.initCozeAPI()
    
    // Configure the "marked" option
    marked.setOptions({
      breaks: true, // Support line breaks
      gfm: true, // Support GitHub Flavored Markdown
      sanitize: false, // Allow HTML (note: more stringent security settings may be required in production environments)
    })
  },
  methods: {
    handleClickOutside() {
      this.$store.dispatch('app/closeSideBar', { withoutAnimation: false })
    },
    
    // Switch between robot display and hide mode
    toggleBot() {
      this.showBot = !this.showBot
    },
    
    // Initialize the Coze API
    async initCozeAPI() {
      try {
        // Dynamic import of Coze API
        const { CozeAPI } = await import('@coze/api')
        
        this.apiClient = new CozeAPI({
          token: 'pat_PRBqXdaI9cjWpoeNobTXtAqK003j7RUzRNDoNXymp2I3uqKaW0dXHKIMsnij26M9',
          baseURL: 'https://api.coze.cn',
          allowPersonalAccessTokenInBrowser: true
        })
        
      } catch (err) {
        console.error('Coze API Failed:', err)
        this.error = 'Coze API Failed: ' + err.message
      }
    },
    
    // Parsing Markdown
    parseMarkdown(content) {
      if (!content) return ''
      return marked.marked(content)
    },
    
    // Get the current time
    getCurrentTime() {
      const now = new Date()
      return now.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' })
    },
    
    // Handling the update operations in the queue
    processQueueItems(queue) {
      if (queue.length === 0) return
      
      // Remove the first operation from the queue
      const operation = queue.shift()
      
      // Perform the operation
      setTimeout(() => {
        operation()
        // Scroll all the way to the bottom of the message history record.
        this.scrollToBottom()
        // Perform the next operation recursively
        this.processQueueItems(queue)
      }, 0)
    },
    
    // Scroll all the way to the bottom of the message history record.
    scrollToBottom() {
      setTimeout(() => {
        const messageHistory = document.querySelector('.message-history')
        if (messageHistory) {
          messageHistory.scrollTop = messageHistory.scrollHeight
        }
      }, 0)
    },
    
    // Send a message to the agent
    async sendMessage() {
      if (!this.apiClient) {
        this.error = 'The API client has not been initialized.'
        return
      }
      
      const message = this.userInput.trim()
      if (!message) {
        return
      }
      
      // Add user messages to the history record
      this.messages.push({
        role: 'user',
        content: message,
        time: this.getCurrentTime()
      })
      
      // Scroll all the way to the bottom of the message history record.
      this.scrollToBottom()
      
      this.loading = true
      this.error = ''
      this.userInput = '' // Clear the input field
      
      try {
        // Use streaming response
        const stream = await this.apiClient.chat.stream({
          bot_id: '7633066797461454902',
          user_id: '123456789',
          additional_messages: this.messages.map(msg => ({
            "content": msg.content,
            "content_type": "text",
            "role": msg.role,
            "type": msg.role === 'user' ? "question" : "answer"
          })),
        })
        
        // Add placeholder for agent messages
        const assistantMessageIndex = this.messages.length
        this.messages.push({
          role: 'assistant',
          content: '',
          time: this.getCurrentTime()
        })
        
        // Handling streaming responses
        let fullResponse = ''
        
        // Create a processing queue to ensure non-blocking processing
        const processQueue = []
        
        // Process the responses block by block
        for await (const chunk of stream) {
          // According to the Coze API documentation, handle responses of different types
          if (chunk.event === 'conversation.message.delta') {
            if (chunk.data && chunk.data.content) {
              fullResponse += chunk.data.content
              
              // Add the update operation to the queue
              processQueue.push(() => {
                // Create a new message object and ensure that Vue can detect the changes
                const updatedMessages = [...this.messages]
                updatedMessages[assistantMessageIndex] = {
                  ...updatedMessages[assistantMessageIndex],
                  content: fullResponse
                }
                this.messages = updatedMessages
              })
              
              // Use setTimeout to ensure non-blocking processing
              if (processQueue.length === 1) {
                this.processQueueItems(processQueue)
              }
            }
          } else if (chunk.event === 'conversation') {
            console.log('Dialogue Information:', chunk.data)
          } else if (chunk.event === 'error') {
            throw new Error(chunk.data?.message || 'Unknown error')
          }
        }
        
        
      } catch (err) {
        console.error('Failed to call the Coze API:', err)
        this.error = 'Call failed: ' + err.message
        // Remove the placeholder for the agent message
        if (this.messages.length > 0 && this.messages[this.messages.length - 1].role === 'assistant') {
          this.messages.pop()
        }
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style lang="scss" scoped>
  @import "~@/styles/mixin.scss";
  @import "~@/styles/variables.scss";

  .app-wrapper {
    @include clearfix;
    position: relative;
    height: 100%;
    width: 100%;
    &.mobile.openSidebar{
      position: fixed;
      top: 0;
    }
  }
  .drawer-bg {
    background: #000;
    opacity: 0.3;
    width: 100%;
    top: 0;
    height: 100%;
    position: absolute;
    z-index: 999;
  }

  .fixed-header {
    position: fixed;
    top: 0;
    right: 0;
    z-index: 9;
    width: calc(100% - #{$sideBarWidth});
    transition: width 0.28s;
  }

  .hideSidebar .fixed-header {
    width: calc(100% - 54px)
  }

  .mobile .fixed-header {
    width: 100%;
  }

  /* Style of intelligent robots */
  .coze-bot {
    position: fixed;
    bottom: 30px;
    right: 30px;
    z-index: 1000;
  }

  /* Robot icon */
  .bot-icon {
    width: 60px;
    height: 60px;
    background-color: #007bff;
    color: white;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    box-shadow: 0 2px 10px rgba(0, 123, 255, 0.3);
    transition: all 0.3s ease;
    &:hover {
      transform: scale(1.1);
      box-shadow: 0 4px 15px rgba(0, 123, 255, 0.4);
    }
    &.active {
      background-color: #0056b3;
    }
  }

  /* Chatting dialogue box */
  .bot-dialog {
    position: absolute;
    bottom: 70px;
    right: 0;
    width: 600px;
    max-height: 500px;
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
    overflow: hidden;
    animation: slideUp 0.3s ease;
  }

  @keyframes slideUp {
    from {
      opacity: 0;
      transform: translateY(20px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  /* Dialog box header */
  .dialog-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px;
    background-color: #007bff;
    color: white;
  }

  .dialog-header h3 {
    margin: 0;
    font-size: 16px;
    font-weight: bold;
  }

  .close-btn {
    background: none;
    border: none;
    color: white;
    cursor: pointer;
    padding: 5px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    &:hover {
      background-color: rgba(255, 255, 255, 0.2);
    }
  }

  /* Dialog box content */
  .dialog-body {
    display: flex;
    flex-direction: column;
    height: 400px;
  }

  /* Message history record */
  .message-history {
    flex: 1;
    padding: 15px;
    overflow-y: auto;
    display: flex;
    flex-direction: column;
    gap: 15px;
  }

  /* Message */
  .message {
    max-width: 80%;
    padding: 10px 15px;
    border-radius: 18px;
    position: relative;
  }

  /* User message */
  .message.user {
    align-self: flex-end;
    background-color: #e3f2fd;
    border-bottom-right-radius: 4px;
  }

  /* Agent message */
  .message.assistant {
    align-self: flex-start;
    background-color: #f1f1f1;
    border-bottom-left-radius: 4px;
  }

  /* Message header */
  .message-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 5px;
    font-size: 12px;
    color: #666;
  }

  .message-role {
    font-weight: bold;
  }

  /* Message content */
  .message-content {
    line-height: 1.5;
    word-wrap: break-word;
  }

  /* Input area */
  .input-area {
    display: flex;
    padding: 15px;
    border-top: 1px solid #e0e0e0;
    background-color: #f9f9f9;
    gap: 10px;
  }

  .input-area input {
    flex: 1;
    padding: 10px 15px;
    border: 1px solid #e0e0e0;
    border-radius: 20px;
    font-size: 14px;
    outline: none;
  }

  .input-area input:focus {
    border-color: #007bff;
    box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
  }

  .input-area button {
    background-color: #007bff;
    color: white;
    border: none;
    padding: 0 20px;
    border-radius: 20px;
    cursor: pointer;
    font-size: 14px;
    white-space: nowrap;
  }

  .input-area button:disabled {
    background-color: #6c757d;
    cursor: not-allowed;
  }

  .input-area button:hover:not(:disabled) {
    background-color: #0056b3;
  }

  /* Markdown Content format */
  .message-content h1,
  .message-content h2,
  .message-content h3,
  .message-content h4,
  .message-content h5,
  .message-content h6 {
    margin: 12px 0 6px 0;
    font-weight: bold;
  }

  .message-content h1 { font-size: 1.3em; }
  .message-content h2 { font-size: 1.2em; }
  .message-content h3 { font-size: 1.1em; }

  .message-content p {
    margin: 6px 0;
  }

  .message-content ul,
  .message-content ol {
    margin: 6px 0;
    padding-left: 20px;
  }

  .message-content li {
    margin: 3px 0;
  }

  .message-content code {
    background-color: #f8f9fa;
    padding: 2px 4px;
    border-radius: 3px;
    font-family: 'Courier New', monospace;
    font-size: 0.9em;
    color: #e83e8c;
  }

  .message-content pre {
    background-color: #f8f9fa;
    padding: 10px;
    border-radius: 4px;
    overflow-x: auto;
    margin: 10px 0;
  }

  .message-content pre code {
    background-color: transparent;
    padding: 0;
    color: #333;
  }

  .message-content blockquote {
    border-left: 4px solid #007bff;
    margin: 10px 0;
    padding: 6px 12px;
    background-color: #f8f9fa;
    color: #6c757d;
  }

  .message-content table {
    border-collapse: collapse;
    width: 100%;
    margin: 10px 0;
  }

  .message-content th,
  .message-content td {
    border: 1px solid #dee2e6;
    padding: 6px 10px;
    text-align: left;
  }

  .message-content th {
    background-color: #f8f9fa;
    font-weight: bold;
  }

  .message-content a {
    color: #007bff;
    text-decoration: none;
  }

  .message-content a:hover {
    text-decoration: underline;
  }

  .message-content strong {
    font-weight: bold;
  }

  .message-content em {
    font-style: italic;
  }

  /* Error message */
  .error {
    padding: 10px 15px;
    background-color: #f8d7da;
    border-top: 1px solid #f5c6cb;
    color: #721c24;
  }

  .error h3 {
    margin: 0 0 5px 0;
    font-size: 14px;
  }

  .error p {
    margin: 0;
    font-size: 12px;
  }

  /* Scroll bar style */
  .message-history::-webkit-scrollbar {
    width: 6px;
  }

  .message-history::-webkit-scrollbar-track {
    background: #f1f1f1;
    border-radius: 3px;
  }

  .message-history::-webkit-scrollbar-thumb {
    background: #c1c1c1;
    border-radius: 3px;
  }

  .message-history::-webkit-scrollbar-thumb:hover {
    background: #a8a8a8;
  }

  /* Responsive design */
  @media (max-width: 768px) {
    .bot-dialog {
      width: 300px;
      right: -50px;
    }
  }
</style>
