# Run training & evaluation on training & dev set for each generated template
for seed in 13
do
    # To save time, we fix these hyper-parameters

    # Since we only use dev performance here, use --no_predict to skip testing
    # TAG=exp-template \
    # TYPE=prompt \
    # TASK=eprstmt \
    # BS=$bs \
    # LR=$lr \
    # SEED=$seed \
    # MODEL=hfl/chinese-roberta-wwm-ext \
    # bash run_experiment.sh "--template_path my_auto_template/eprstmt/16-$seed.txt --template_id $template_id --no_predict"
    # # To save time, we fix these hyper-parameters
    # bs=8
    # lr=1e-5

    # # Since we only use dev performance here, use --no_predict to skip testing
    # TAG=exp-template \
    # TYPE=prompt \
    # TASK=SST-2 \
    # BS=$bs \
    # LR=$lr \
    # SEED=$seed \
    # MODEL=roberta-large \
    # bash run_experiment.sh "--template_path my_auto_template/SST-2/16-$seed.txt --template_id $template_id --no_predict"

    SEED=$seed
    # TASK=eprstmt
    # TASK=iflytek
    TASK=tnews
    # TASK=ocnli
    TYPE=prompt
    TAG=exp-template

    # TASK_EXTRA="--max_seq_len 140 --first_sent_limit 64 --other_sent_limit 64"
    TASK_EXTRA="--max_seq_len 260 --first_sent_limit 256"

    MODEL=hfl/chinese-roberta-wwm-ext
    BS=8
    LR=1e-5

    TRIAL_IDTF=$RANDOM
    DATA_DIR=data/k-shot/$TASK/$K-$
    TEMPLATE_PATH=my_auto_template/$TASK/16-$seed.txt

    # 看模板文件里包含多少个模板
    NUM_TEMPLATE=$(cat $TEMPLATE_PATH| wc -l)
    for (( template_id=0; template_id < $NUM_TEMPLATE; ++template_id )) 
    do
        python run.py \
            --seed $SEED \
            --task_name $TASK \
            --data_dir data/k-shot/$TASK/16-$SEED \
            --overwrite_output_dir \
            --do_train \
            --do_eval \
            --no_predict \
            --evaluate_during_training \
            --model_name_or_path $MODEL\
            --few_shot_type $TYPE \
            --num_k 16 \
            --learning_rate $LR \
            --max_steps 300 \
            --eval_steps 100 \
            --per_device_train_batch_size 4 \
            --per_device_eval_batch_size 16 \
            --learning_rate 1e-5 \
            --output_dir result/$TASK-$TYPE-$K-$SEED-$MODEL-$TRIAL_IDTF \
            --template_path $TEMPLATE_PATH \
            --template_id $template_id \
            --tag $TAG \
            --mapping "{100: '事', 101: '文', 102: '娱', 103: '体', 104: '财', 106: '房', 107: '车', 108: '教', 109: '科', 110: '军', 112: '旅', 113: '国', 114: '股', 115: '农', 116: '游'}" \
            $TASK_EXTRA \
            # --mapping '{"contradiction": "不", "neutral": "或", "entailment": "是"}' \
            # --mapping "{8: '公共交通', 30: '情侣社交', 102: '摄影修图', 58: '高等教育', 42: '百科', 99: '银行', 47: '短视频', 72: '母婴', 46: '视频', 80: '买房', 82: '电子产品', 116: '经营', 38: '教辅', 21: '经营养成', 92: '支付', 1: '地图导航', 87: '美妆美业', 66: '酒店', 83: '问诊挂号', 73: '驾校', 41: '杂志', 51: 'K歌', 23: 'MOBA', 105: '二手', 61: '语言(非英语)', 67: '行程管理', 111: '购物咨询', 26: '即时通讯', 74: '违章', 96: '理财', 20: '棋牌中心', 103: '相机', 84: '养生保健', 53: '中小学', 65: '铁路', 19: '体育竞技', 52: '成人', 75: '汽车咨询', 10: '社区服务', 55: '公务员', 112: '笔记', 24: '辅助工具', 81: '装修家居', 101: '影像剪辑', 63: '综合预定', 62: '旅游资讯', 29: '婚恋社交', 2: '免费WIFI', 115: '女性', 85: '医疗服务', 100: '美颜', 108: '外卖', 43: '影视娱乐', 44: '求职', 17: '休闲益智', 106: '电商', 118: '其他', 13: '仙侠', 28: '论坛圈子', 77: '日常养车', 25: '约会社交', 71: '亲子儿童', 94: '股票', 37: '技术', 90: '体育咨讯', 54: '职考', 91: '运动健身', 11: '薅羊毛', 39: '问答交流', 27: '工作社交', 36: '小说', 49: '直播', 59: '成人教育', 5: '快递物流', 56: '英语', 93: '保险', 104: '绘画', 64: '民航', 86: '减肥瘦身', 97: '彩票', 109: '电影票务', 107: '团购', 45: '兼职', 60: '艺术', 70: '工具', 79: '租房', 48: '音乐', 95: '借贷', 110: '社区超市', 7: '家政', 32: '生活社交', 113: '办公', 76: '汽车交易', 78: '行车辅助', 16: '射击游戏', 15: '飞行空战', 98: '记账', 114: '日程管理', 40: '搞笑', 9: '政务', 0: '打车', 22: '策略', 18: '动作类', 117: '收款', 68: '民宿短租', 3: '租车', 57: '视频教育', 34: '新闻', 35: '漫画', 31: '社交工具', 89: '餐饮店', 6: '婚庆', 50: '电台', 4: '同城服务', 14: '卡牌', 88: '菜谱', 33: '微博博客', 69: '出国', 12: '魔幻'}"
            # --mapping "{'Negative':'差','Positive':'好'}" 
    done
done

# Sort templates according to their score
python tools/sort_template.py --condition "{'tag':'exp-template','task_name':'$TASK'}" --template_dir my_auto_template
