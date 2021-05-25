SEED=13
# TASK=eprstmt
# TASK=tnews
TASK=ocnli

MODEL=hfl/chinese-roberta-wwm-ext
# MODEL=hfl/chinese-roberta-wwm-ext-large
TYPE=prompt

K=16
# 在此设置 max len
# 稍小的max len加快训练速度
TASK_EXTRA="--max_seq_len 140 --first_sent_limit 64 --other_sent_limit 64"
# MAX_LEN=256
# FIRST_LIMIT=256

LR=1e-5

MAX_STEP=1000
# MAX_STEP=300
# Validation steps
EVAL_STEP=100

# TEMPLATE=*cls**sent_0*_。_*mask*点!*sep+*
# MAPPING="{'Negative':'差','Positive':'好'}"
# 字符串表示的dict没有任何空格！
# MAPPING="{100:'事',101:'文',102:'娱',103:'体',104:'财',106:'房',107:'车',108:'教',109:'科',110:'军',112:'旅',113:'国',114:'股',115:'农',116:'游'}"
MAPPING="{'contradiction':'不','neutral':'或','entailment':'是'}"
TEMPLATE_PATH=my_auto_template/$TASK/$K-$SEED.sort.txt

TRIAL_IDTF=$RANDOM
DATA_DIR=data/k-shot/$TASK/$K-$SEED

FILTER_MODEL=distiluse-base-multilingual-cased-v1



python run.py \
  --task_name $TASK \
  --data_dir $DATA_DIR \
  --overwrite_output_dir \
  --do_train \
  --do_eval \
  --do_predict \
  --evaluate_during_training \
  --model_name_or_path $MODEL \
  --few_shot_type $TYPE \
  --num_k $K \
  --per_device_train_batch_size 4 \
  --per_device_eval_batch_size 16 \
  --learning_rate $LR \
  --max_steps $MAX_STEP \
  --eval_steps $EVAL_STEP \
  --output_dir result/$TASK-$TYPE-$K-$SEED-$MODEL-$TRIAL_IDTF \
  --seed $SEED \
  --template_path $TEMPLATE_PATH \
  --template_id 0 \
  --mapping $MAPPING \
  $TASK_EXTRA
  # --max_seq_length $MAX_LEN \
  # --first_sent_limit $FIRST_LIMIT \
  # --double_demo \
  # --demo_filter \
  # --demo_filter_model sbert-$FILTER_MODEL
#   --logging_steps $EVAL_STEP \