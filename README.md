# PT
ros openpose docker container

So, this machine is pretty much bare bones ros and openpose on a cuda-8 docker image. I still didn't add submodules.

I am thinking of first just publishing an array of whatever skeleton definitions (not sure if it is looking into the skeleton msg definition from ros and using that). 
Probably a message with fields for face and hands is the right way to go about it here. 

A KNN (me, unpublished) or K-Means (many persons, literature) that abstracts rotation (and possibly reflection?), should be able to classify whole body actions of a single subject that has all their limbs non-occluded. This is the simplest case and still it presumes a decent dataset that has enough data for us to understand that action. We tested before (unpublished) that an LSTM does not help too much here (if at all), but that might be because of noisy data and very small datasets.

Other more general situations are presented below under issues.

## Issues:

1. Just using skeletons could be messy if we have more than 1 person in the frame. Then there are some possibilities here:

- the action requires more than 1 person (say hugging or shaking hands). This is tricky. So far I can't solve it. We will avoid those. 
- there is one person doing the action and other people are just there. Also tricky. Not sure what to do here. 

And there is still the issue of missing joints: In case a frame does not have all the joints, what do I do? (say self occlusions).
I can use flows to fix this to an extent, but I can't be sure about how good the results will be. 

2. Actions involving objects. 

Well, here we probably want to find the objects as well, since the action requires them.
It is the difference of watching someone mime an action and seeing what they are doing with a lot of other visual cues. 
The whole architecture for action classifications in a general sense probably has another "layer" that combines posture information with information from objects and the scene background as well. 

3. Composed actions. 

Say I am sitting and sipping a coffee. Those are 2 actions happening at the same time. What about that now?

4. Not whole body actions. 

If an action is being performed by only a part of the subject (say head and right hand), as in sipping a cup of coffee, the algorithm has to understand that leg posture is irrelevant for this. 

## TODO

- init submodules
- create catkin_ws (it will need the old cv_bridge, I think)
- create repo to publish skeletons to ros
