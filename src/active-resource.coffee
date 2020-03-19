import axios from 'axios'
import es6Promise from 'es6-promise'
import Qs from 'qs'
import _ from 'underscore'
import s from 'underscore.string'
import 'underscore.inflection'

unless typeof window == undefined || (typeof exports == 'object' && typeof module != 'undefined')
  window.Promise = es6Promise.Promise

export default class ActiveResource
