<template>
    <div> 
        <div v-bind:key="index" v-for="(files, index) in attachmentList">
            <Card style="margin-left:10px;margin-right:10px;margin-top:5px;margin-bottom:3px;">
                <p slot="title">
                    <span style="float:left">
                        <div v-if="files.email">
                            <avatar v-if="files.image_url" :username="files.email" :src="files.image_url" :size="30"></avatar>
                            <avatar v-else :username="files.email" :size="30" color="#fff"></avatar>
                        </div>
                    </span>
                    <span class="attachment-username">
                        <span style="font-size:10px">{{files.fullname}} </span>
                        <!-- <div class="attachment-time">{{file}}</div> -->
                    </span>
                    <Dropdown @on-click="moreActionMenuClick" trigger="click" placement="bottom" class="close-btn">
                        <a href="javascript:void(0)">
                            <Icon style="font-size:20px;color:rgb(149, 152, 157)" type="android-more-horizontal"></Icon>
                        </a>
                        <DropdownMenu slot="list">
                            <DropdownItem name="1"><span @click="deleteAttachment(files, index)">Delete</span></DropdownItem>
                            <DropdownItem class="hidden" name="2">share <span class="hidden">{{files}}</span></DropdownItem>
                        </DropdownMenu>
                    </Dropdown>
                    <!-- <button class="hidden close-btn" @click="deleteAttachment(files, index)">
                        <a v-show="isDeleteAttachment" class="fa fa-trash-o" aria-hidden="true" />
                    </button> -->
                </p>
                <div class="BlockStory-body">
                    <div class="AddedAttachmentStory-body">
                        <div v-if="isImage(files.file_name)" class="AddedAttachmentStory-thumbnailContainer">
                            <a :href="files.file_url" target="_blank">
                                <img class="image-preview" :src="files.file_url">
                            </a>
                        </div>
                        <iframe v-else class="Thumbnail-image" v-bind:src="imgURL(files.file_url)">Hemant</iframe>
                        <div class="">
                            <a class="AddedAttachmentStory-link" style="color:inherit; text-decoration: none;font-size:11px" :href="files.file_url" target="_blank" tabindex="-1">
                                <i><span style="color:black;font-size:12px">file:</span>{{files.file_name}}</i>
                            </a>
                            <button class="" @click="deleteAttachment(files, index)">
                                <a v-show="isDeleteAttachment" class="fa fa-close" />
                            </button>
                        </div>
                    </div>
                </div>
                <div class="attachment-card-footer">
                    <span style="float:left;margin-top:10px">
                        <i class="fa fa-thumbs-o-up hidden" style="font-size:25px;color:rgb(149, 152, 157)" aria-hidden="true"></i>
                        <i class="fa fa-comments hidden" style="font-size:25px;color:rgb(149, 152, 157);margin-left:30px" aria-hidden="true"></i>
                        <a :href="files.file_url" download>
                            <i class="fa fa-arrow-circle-o-down" style="font-size:25px; color:rgb(211, 211, 211);" aria-hidden="true"></i>
                        </a>
                        <!-- <button class="close-btn" @click="deleteAttachment(files, index)">
                            <a v-show="isDeleteAttachment" class="fa fa-trash-o" aria-hidden="true" />
                        </button> -->
                    </span>
                </div>
                <div class="attachment-comment-footer hidden">
                    <span style="float:left;margin-top:10px;width:100%">
                        <Input type="textarea" :autosize="{minRows: 1,maxRows: 5}" placeholder="Enter comments...">
                        </Input>
                        <div style="width: 475px;" class="hidden">
                            <el-tabs type="border-card">
                                <el-tab-pane>
                                    <span slot="label">
                                        <i class="el-icon-date"></i> Html editor</span>
                                </el-tab-pane>
                                <el-tab-pane label="Markdown editor">
                                    <div class="markdownEditor">
                                        <markdown-editor v-model="content" ref="markdownEditor" :value="content" :configs="configs">
                                        </markdown-editor>
                                    </div>
                                </el-tab-pane>
                            </el-tabs>
                        </div>
                    </span>
                </div> 
            </Card>
            <div class="hidden">
                <a target="_blank" v-bind:href="files.file_url">{{ files.file_name }}
                    <ui-progress-linear color="primary" type="determinate" :progress="$store.state.progress" v-show="filteredTodo.attachmentprogress"
                        v-if="index === attachmentList.length-1">
                    </ui-progress-linear>
                </a>
                <button class="" @click="deleteAttachment(files, index)">
                    <a v-show="isDeleteAttachment" class="fa fa-close" />
                </button>
                <iframe v-bind:src="imgURL(files.file_url)" frameborder="0"></iframe>

                <div style="float:right;" v-if="index === btnClickedIndex">
                    <!--<span style="float:right;margin-right: 40px;" v-if="index === btnClickedIndex">-->
                    <ui-progress-circular color="black" type="indeterminate" v-show="filteredTodo.deleteprogress" class="circularProgress" :size="20">
                    </ui-progress-circular>
                </div>
            </div>

        </div>
        <div class="nav1">
            <div class="share">
                <label for="upload">
                <i class="fa fa-paperclip"></i>
                <input id="upload" type="file" @change="onFileChange($event)" style="display:none" />
                </label>
            </div>
        </div>
    </div>
</template>
<script>
/* eslint-disable*/
import Vue from "vue";
import { mapGetters } from "vuex";
import iView from "iview";
import "iview/dist/styles/iview.css";
import Avatar from "vue-avatar/src/Avatar";
import { markdownEditor } from "vue-simplemde";
import Ckeditor from "vue-ckeditor2";
import notify from "./notify.js";
Vue.use(iView);
export default {
  props: ["filteredTodo", "isDeleteAttachment"],
  data: function() {
    return {
      btnClickedIndex: 0,
      content: "",
      commentText: "",
      configs: {
        toolbar: [
          "undo",
          "redo",
          "bold",
          "italic",
          "strikethrough",
          "heading",
          "quote",
          "unordered-list",
          "ordered-list",
          "clean-block",
          "link",
          "image",
          "table",
          "horizontal-rule",
          "preview",
          "side-by-side",
          "fullscreen",
          "guide"
        ],
        placeholder: "Type here..."
      },
      file:{}
    };
  },
  computed: {
    ...mapGetters({
      getFiles: "getAttachment"
    }),
    attachmentList() {
      var array = this.getFiles(this.filteredTodo.id);
      this.attachmentDetailList(array);
      return array;
    }
  },
  methods: {
    deleteAttachment(objAttachment, btnIndex) {
      this.btnClickedIndex = btnIndex;
      this.$store.dispatch("deleteAttachmentFromDB", objAttachment);
    },
    onFileChange(e) {
      var fileChooser = e.target; // document.getElementById('file');
      try {
        this.$store.dispatch("selectFile", {
          file: fileChooser,
          taskId: this.filteredTodo.id,
          level: this.filteredTodo.level,
          cb: function(result) {
            fileChooser.value = "";
            if (result == "success") {
            } else {
              console.log("File upload fail");
              $.notify.defaults({ className: "error" });
              $.notify("File upload error", { globalPosition: "top center" });
            }
          }
        });
      } catch (exception) {
        console.log("File upload error");
      }
    },
    imgURL(url) {
      let doc = "http://docs.google.com/gview?url=" + url + "&embedded=true";
      return doc;
    },
    isImage(fileName) {
      return fileName.match(/.(jpg|jpeg|png|gif)$/i);
    },
    attachmentDetailList: function(attachList) {
      attachList.forEach(function(c) {
        let userId = c.uploadedBy;
        let userIndex = _.findIndex(this.$store.state.arrAllUsers, function(m) {
          return m._id === userId;
        });
        if (userIndex < 0) {
        } else {
          var id = this.$store.state.arrAllUsers[userIndex]._id;
          c.fullname = this.$store.state.arrAllUsers[userIndex].fullname;
          (c.image_url = this.$store.state.arrAllUsers[userIndex].image_url),
            (c.email = this.$store.state.arrAllUsers[userIndex].email);
        }
      }, this);
    },
    moreActionMenuClick(key,val) {
      console.log("moreActionMenuClick",key)
      if (val == 1) {
        
      }
    }
  },
  components: {
    Avatar,
    markdownEditor,
    Ckeditor
  }
};
</script>
<style>
.attachment-nav {
  right: 42px;
  z-index: 20;
  width: 45px;
  bottom: 15px;
  height: 45px;
  display: block;
  position: absolute;
  line-height: 45px;
  border-radius: 50%;
  box-shadow: 0 0 5px 0 rgba(0, 0, 0, 0.75);
}

.attachment-mask {
  z-index: 21;
  color: #fff;
  width: inherit;
  height: inherit;
  cursor: pointer;
  font-size: 28px;
  text-align: center;
  border-radius: 50%;
  position: absolute;
  background: #f23363;
  -webkit-transition: all 0.1s ease-in-out 0s;
  transition: all 0.1s ease-in-out 0s;
}

.thumbnail {
  width: 300px;
  height: 160px;
}

.thumbnail iframe {
  width: 900px;
  height: 480px;
  -webkit-transform-origin: 0 0;
  -moz-transform-origin: 0 0;
  transform-origin: 0 0;
  -webkit-transform: scale(0.3, 0.3);
  -moz-transform: scale(0.3, 0.3);
  transform: scale(0.3, 0.3);
  overflow: hidden;
}

.Thumbnail-image {
  border: 1px solid #b7bfc6;
  display: inline-block;
  max-width: 100%;
  position: relative;
  z-index: 1;
  background: url("../assets/ob_logo.svg");
  background-repeat: no-repeat;
  background-size: 100% 100%;
}

.image-preview {
  width: 300px;
  height: 160px;
}

.ivu-card-head p,
.ivu-card-head-inner {
  padding-bottom: 30px;
}

.attachment-username {
  text-align: -webkit-left;
  text-align: left;
  margin-left: 10px;
  margin-top: -3px;
  font-size: 8px;
  color: gray;
  float: left;
}

.attachment-time {
  margin-top: -5px;
  font-size: 10px;
}

.ivu-card-head {
  padding: 10px 10px;
}

.attachment-card-footer {
  border-top: 1px solid #e9eaec;
  height: 36px;
  padding-left: -16px;
  padding-right: -16px;
  line-height: 36px;
  text-align: center;
}

.attachment-comment-footer {
  margin-top: 10px;
  border-top: 1px solid #e9eaec;
  padding-left: -16px;
  padding-right: -16px;
  line-height: 36px;
  text-align: center;
  display: inline-block;
  width: 100%;
}

.close-btn {
  float: right;
}

.AddedAttachmentStory-body {
  text-align: -webkit-left;
  text-align: left;
  margin: 10px;
}
</style>