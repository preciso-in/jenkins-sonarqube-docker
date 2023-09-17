All billing costs are from Compute Engine. The avg cost is Rs 24 per day. There are some small networking costs but they have been discounted.

You can save time creating and installing software by stopping instances instead of deleting them.
However, they will still incur charges for associated resources like Storage, n/w, etc.
But these charges are very low and much better compared to a running instance.

Boot disks (Zonal, 10GB) are charged at $1 per month. So, it is ok to use them.

It is better to use preemptible machines because they will be deleted after a day. It does not matter if the boot disks get used for only a small amount of time.

An N1 standard machine (Preemtible) is charged at $10 per month.
So 1 machine costs Rs 800/- per month or Rs 27/- per day.
Or it will be charged Rs 1.15/- per hour.

To stop an instance, use
$ gcloud compute instances stop my-instance

To restart an instance, use
$ gcloud compute instances start my-instance

To check status of an instance use,
$ gcloud compute instances describe INSTANCE_NAME --format="get(status)"

What happens when we run a command on a stopped instance?

SSH does not work.
However, other commands might work.
For ex. check what happens when you use
$ gcloud compute instances describe $JENKINS_SERVER_NAME
