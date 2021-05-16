SEED=13
TASK=eprstmt

MODEL=hfl/chinese-roberta-wwm-ext
# MODEL=hfl/chinese-roberta-wwm-ext-large
TYPE=prompt-demo

K=16
# 稍小的max len加快训练速度
MAX_LEN=128
FIRST_LIMIT=128
LR=1e-5

MAX_STEP=1000
# MAX_STEP=300
# Validation steps
EVAL_STEP=100

# TEMPLATE=*cls**sent_0*_。_*mask*点!*sep+*
MAPPING="{'Negative':'差','Positive':'好'}"
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
  --mapping $MAPPING \
  --template_path $TEMPLATE_PATH \
  --template_id 0 \
  --demo_filter \
  --max_seq_length $MAX_LEN \
  --first_sent_limit $FIRST_LIMIT \
  --double_demo \
  --demo_filter_model sbert-$FILTER_MODEL
#   --logging_steps $EVAL_STEP \